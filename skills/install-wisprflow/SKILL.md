---
name: install-wisprflow
description: Download and install Wispr Flow (AI voice dictation) on Mac (Intel or Apple Silicon), Windows, or Linux. Use when setting up Wispr Flow on a new machine.
---

# Install Wispr Flow

Detect the OS/arch, download the right build, install it, and launch.

## Download URLs (official, no auth required)

| Platform | URL |
|---|---|
| Mac Apple Silicon | `https://dl.wisprflow.ai/mac-apple/latest` |
| Mac Intel | `https://dl.wisprflow.ai/mac-intel/latest` |
| Windows | Check https://wisprflow.ai/downloads |
| Linux | Not officially supported — check docs |

## Mac (auto-detect arch)

```bash
ARCH=$(uname -m)
if [ "$ARCH" = "arm64" ]; then
  URL="https://dl.wisprflow.ai/mac-apple/latest"
else
  URL="https://dl.wisprflow.ai/mac-intel/latest"
fi

curl -L "$URL" -o ~/Downloads/WisprFlow.dmg --progress-bar
VOLUME=$(hdiutil attach ~/Downloads/WisprFlow.dmg -nobrowse | grep Volumes | awk '{print $NF}')
cp -R "$VOLUME/Wispr Flow.app" /Applications/
hdiutil detach "$(hdiutil info | grep "$VOLUME" | awk '{print $1}')" 2>/dev/null || true
open "/Applications/Wispr Flow.app"
```

## Windows

Direct download links aren't stable — send the user to https://wisprflow.ai/downloads to grab the `.exe` installer manually.

## After install

User must log in with their Wispr Flow account (Google/Apple/Microsoft/SSO). No credentials to script — login is interactive.
