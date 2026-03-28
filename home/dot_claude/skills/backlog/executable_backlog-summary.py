#!/usr/bin/env python3
"""Summarize .backlog/ issues grouped by status, with ready/blocked split for not-started."""

import sys
from pathlib import Path


STATUS_ORDER = [
    "needs-triage",
    "not-started",
    "in-progress",
    "on-hold",
    "abandoned",
    "complete",
]


def parse_frontmatter(text: str) -> dict:
    """Extract YAML frontmatter fields from a markdown file. Simple line-by-line parser."""
    lines = text.splitlines()
    if not lines or lines[0].strip() != "---":
        return {}
    fields = {}
    i = 1
    current_key = None
    current_list = None
    while i < len(lines):
        line = lines[i]
        if line.strip() == "---":
            break
        # List item continuation (indented)
        if line.startswith("  - ") and current_list is not None:
            current_list.append(line.strip()[2:].strip())
        elif line.startswith("- ") and current_key == "depends-on":
            if current_list is None:
                current_list = []
                fields[current_key] = current_list
            current_list.append(line[2:].strip())
        elif ":" in line and not line.startswith(" "):
            current_list = None
            key, _, val = line.partition(":")
            key = key.strip()
            val = val.strip()
            if val == "":
                # Might be a list key — set up for list continuation
                current_key = key
                current_list = []
                fields[key] = current_list
            else:
                # Inline comment stripping (e.g. "P2  # Medium")
                val = val.split("#")[0].strip()
                fields[key] = val
                current_key = key
        i += 1
    # Clean up empty lists
    for k, v in list(fields.items()):
        if isinstance(v, list) and len(v) == 0:
            fields[k] = []
    return fields


def load_backlog(backlog_dir: Path) -> dict:
    """Load all issues from .backlog/. Returns dict keyed by slug."""
    issues = {}
    for path in sorted(backlog_dir.glob("*.md")):
        text = path.read_text()
        fm = parse_frontmatter(text)
        if not fm:
            continue
        slug = fm.get("slug") or path.stem
        fm["_path"] = str(path)
        issues[slug] = fm
    return issues


def is_ready(slug: str, issues: dict, seen: set = None) -> bool:
    """An item is ready iff all depends-on slugs are complete (recursively)."""
    if seen is None:
        seen = set()
    if slug in seen:
        return False  # cycle — treat as not ready
    seen.add(slug)
    issue = issues.get(slug)
    if issue is None:
        return False
    deps = issue.get("depends-on") or []
    if isinstance(deps, str):
        deps = [deps]
    for dep in deps:
        dep_issue = issues.get(dep)
        if dep_issue is None:
            return False
        if dep_issue.get("status") != "complete":
            return False
        if not is_ready(dep, issues, seen.copy()):
            return False
    return True


def blocked_by(slug: str, issues: dict) -> list:
    """Return list of unmet dep slugs for a not-started item."""
    issue = issues.get(slug, {})
    deps = issue.get("depends-on") or []
    if isinstance(deps, str):
        deps = [deps]
    unmet = []
    for dep in deps:
        dep_issue = issues.get(dep)
        if dep_issue is None or dep_issue.get("status") != "complete":
            unmet.append(dep)
    return unmet


def print_summary(issues: dict) -> None:
    grouped = {s: [] for s in STATUS_ORDER}
    for slug, issue in issues.items():
        status = issue.get("status", "needs-triage")
        if status in grouped:
            grouped[status].append((slug, issue))
        else:
            print(f"Warning: unknown status '{status}' on {slug}, skipping", file=sys.stderr)

    for status in STATUS_ORDER:
        items = grouped[status]
        if not items:
            continue

        if status == "not-started":
            ready_items = [(s, i) for s, i in items if is_ready(s, issues)]
            blocked_items = [(s, i) for s, i in items if not is_ready(s, issues)]

            if ready_items:
                print("\n## not-started / Ready\n")
                for slug, issue in ready_items:
                    desc = issue.get("description", "(no description)")
                    pri = issue.get("priority", "")
                    print(f"  [{pri}] {slug} — {desc}")

            if blocked_items:
                print("\n## not-started / Blocked\n")
                for slug, issue in blocked_items:
                    desc = issue.get("description", "(no description)")
                    pri = issue.get("priority", "")
                    unmet = blocked_by(slug, issues)
                    blockers = ", ".join(unmet)
                    print(f"  [{pri}] {slug} — {desc}")
                    print(f"         blocked by: {blockers}")
        else:
            print(f"\n## {status}\n")
            for slug, issue in items:
                desc = issue.get("description", "(no description)")
                pri = issue.get("priority", "")
                print(f"  [{pri}] {slug} — {desc}")


def main():
    backlog_dir = Path(".backlog")
    if not backlog_dir.exists():
        print("No .backlog/ directory found in current directory.", file=sys.stderr)
        sys.exit(1)

    issues = load_backlog(backlog_dir)
    if not issues:
        print("No issues found in .backlog/")
        return

    print_summary(issues)


if __name__ == "__main__":
    main()
