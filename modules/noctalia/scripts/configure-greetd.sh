#!/usr/bin/env bash
# purpose: configure greetd to launch the packaged Noctalia Greeter session
# distro: CachyOS / systemd
# runs as: root (dcli post_install_hook)
# idempotent: yes (only writes when the default session differs)
# calling hook: noctalia post_install, behavior always
set -euo pipefail

session_command="$(command -v noctalia-greeter-session || true)"
config_file="/etc/greetd/config.toml"

if [[ -z "${session_command}" ]]; then
  echo "configure-greetd: noctalia-greeter-session is not installed." >&2
  exit 1
fi

python3 - "${config_file}" "${session_command}" <<'PY'
from __future__ import annotations

import re
import shutil
import sys
from datetime import datetime, timezone
from pathlib import Path

config_path = Path(sys.argv[1])
session_command = sys.argv[2]

existing = config_path.read_text() if config_path.exists() else ""
section_pattern = re.compile(
    r"(?ms)^\[default_session\]\s*\n(?P<body>.*?)(?=^\[|\Z)"
)


def update_section(match: re.Match[str]) -> str:
    body = match.group("body")

    def set_value(content: str, key: str, value: str) -> str:
        pattern = re.compile(rf"(?m)^{re.escape(key)}\s*=\s*.*$")
        line = f'{key} = "{value}"'
        if pattern.search(content):
            return pattern.sub(line, content, count=1)
        return content.rstrip("\n") + "\n" + line + "\n"

    body = set_value(body, "command", session_command)
    body = set_value(body, "user", "greeter")
    return "[default_session]\n" + body


if section_pattern.search(existing):
    updated = section_pattern.sub(update_section, existing, count=1)
else:
    separator = "" if not existing or existing.endswith("\n\n") else "\n"
    updated = (
        existing
        + separator
        + "[default_session]\n"
        + f'command = "{session_command}"\n'
        + 'user = "greeter"\n'
    )

if updated != existing:
    config_path.parent.mkdir(parents=True, exist_ok=True)
    if config_path.exists():
        timestamp = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")
        shutil.copy2(config_path, config_path.with_name(f"config.toml.dcli-backup-{timestamp}"))
    config_path.write_text(updated)
    print(f"configure-greetd: configured {config_path} for Noctalia Greeter.")
else:
    print("configure-greetd: Noctalia Greeter session is already configured.")
PY
