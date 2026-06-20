#!/usr/bin/env python3
"""
Reads .zsh_plugins.txt and rewrites the plugins table in README.md
between <!-- PLUGINS_START --> and <!-- PLUGINS_END --> markers.

Descriptions are cached in scripts/plugin_descriptions.json.
Unknown plugins are looked up via GitHub Models (gpt-4o-mini) using
the GITHUB_TOKEN available in Actions — no separate API key needed.
"""

import json
import os
import re
import sys
import urllib.request
import urllib.error
from pathlib import Path

REPO_ROOT = Path(__file__).parent.parent
PLUGINS_FILE = REPO_ROOT / ".zsh_plugins.txt"
README_FILE = REPO_ROOT / "README.md"
CACHE_FILE = Path(__file__).parent / "plugin_descriptions.json"

START_MARKER = "<!-- PLUGINS_START -->"
END_MARKER = "<!-- PLUGINS_END -->"

GITHUB_MODELS_URL = "https://models.inference.ai.azure.com/chat/completions"
GITHUB_MODEL = "gpt-4o-mini"

SKIP_EXACT = {
    "getantidote/use-omz",
    "ohmyzsh/ohmyzsh path:lib",
}


def parse_plugins(path: Path) -> list[tuple[str, bool]]:
    """Returns list of (plugin_string, is_commented) tuples."""
    results = []
    for raw in path.read_text().splitlines():
        line = raw.strip()
        if not line:
            continue
        commented = line.startswith("#")
        plugin = line.lstrip("# ").strip()
        if commented and "/" not in plugin:
            continue  # section header comment
        if plugin in SKIP_EXACT:
            continue
        results.append((plugin, commented))
    return results


def load_cache() -> dict[str, str]:
    if CACHE_FILE.exists():
        return json.loads(CACHE_FILE.read_text())
    return {}


def save_cache(cache: dict[str, str]) -> None:
    CACHE_FILE.write_text(json.dumps(cache, indent=2, sort_keys=True) + "\n")


def fetch_description(plugin: str, token: str) -> str:
    prompt = (
        f"Give a single short sentence (under 10 words) describing what the zsh plugin "
        f"'{plugin}' does. Reply with only the description, no punctuation at the end, "
        f"no preamble, no quotes."
    )
    payload = json.dumps({
        "model": GITHUB_MODEL,
        "messages": [{"role": "user", "content": prompt}],
        "max_tokens": 40,
        "temperature": 0.2,
    }).encode()

    req = urllib.request.Request(
        GITHUB_MODELS_URL,
        data=payload,
        headers={
            "Content-Type": "application/json",
            "Authorization": f"Bearer {token}",
        },
    )
    try:
        with urllib.request.urlopen(req, timeout=15) as resp:
            data = json.loads(resp.read())
            return data["choices"][0]["message"]["content"].strip()
    except urllib.error.HTTPError as e:
        print(f"  WARNING: GitHub Models API error for {plugin!r}: {e}", file=sys.stderr)
        return "—"
    except Exception as e:
        print(f"  WARNING: Unexpected error for {plugin!r}: {e}", file=sys.stderr)
        return "—"


def get_descriptions(
    plugins: list[tuple[str, bool]], cache: dict[str, str], token: str | None
) -> dict[str, str]:
    missing = [p for p, _ in plugins if p not in cache]
    if missing and not token:
        print(
            f"WARNING: {len(missing)} plugin(s) have no cached description and "
            "GITHUB_TOKEN is not set. They will render as '—'.",
            file=sys.stderr,
        )
    if missing and token:
        print(f"Fetching descriptions for {len(missing)} new plugin(s)...")
        for plugin in missing:
            print(f"  → {plugin}")
            cache[plugin] = fetch_description(plugin, token)
        save_cache(cache)
    return cache


def build_table(plugins: list[tuple[str, bool]], descriptions: dict[str, str]) -> str:
    rows = ["| Plugin | Purpose |", "|---|---|"]
    for plugin, commented in plugins:
        desc = descriptions.get(plugin, "—")
        if commented:
            display = f"~~`{plugin}`~~ *(disabled)*"
        else:
            display = f"`{plugin}`"
        rows.append(f"| {display} | {desc} |")
    return "\n".join(rows)


def update_readme(readme: Path, table: str) -> bool:
    content = readme.read_text()
    pattern = re.compile(
        rf"{re.escape(START_MARKER)}.*?{re.escape(END_MARKER)}",
        re.DOTALL,
    )
    replacement = f"{START_MARKER}\n{table}\n{END_MARKER}"
    new_content, count = pattern.subn(replacement, content)
    if count == 0:
        print("ERROR: markers not found in README.md", file=sys.stderr)
        print(f"  Expected: {START_MARKER!r} ... {END_MARKER!r}", file=sys.stderr)
        sys.exit(1)
    if new_content == content:
        print("README.md already up to date.")
        return False
    readme.write_text(new_content)
    print("README.md updated.")
    return True


def main() -> None:
    token = os.environ.get("GITHUB_TOKEN")
    plugins = parse_plugins(PLUGINS_FILE)
    cache = load_cache()
    descriptions = get_descriptions(plugins, cache, token)
    table = build_table(plugins, descriptions)
    update_readme(README_FILE, table)


if __name__ == "__main__":
    main()
