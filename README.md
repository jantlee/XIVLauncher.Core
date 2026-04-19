# XIVLauncher.Core - Patch Retry Fork

Personal fork adding per-patch retry logic to the patcher.

## Problem

The upstream patcher cancels all concurrent downloads when a single patch fails its hash check. On fresh installs, this means restarting the patch process repeatedly until every file downloads without in-transit corruption. No automatic retry exists.

## Fix

- Failed patches are deleted and re-downloaded automatically (up to 3 retries, 2.5s delay)
- Other concurrent downloads are unaffected by a single patch failure
- Fatal error only after all retries are exhausted for a given patch

Single file changed: `PatchManager.cs` in the `FFXIVQuickLauncher` submodule.

## Install (SteamOS)

```bash
cd ~ && curl -sSL https://raw.githubusercontent.com/jantlee/XIVLauncher.Core/patch-retry/install.sh | bash
```

Then copy the built binary to where XLM loads it:

```bash
cp ~/xlcore-patched/XIVLauncher.Core ~/.local/share/Steam/compatibilitytools.d/XLM/xlcore/XIVLauncher.Core
```

Launch FFXIV through Steam as usual.

## Rebuild After XLM Update

XLM auto-updates will overwrite the patched binary. Re-run:

```bash
cd ~/XIVLauncher.Core && git pull && export DOTNET_ROOT=$HOME/.dotnet && export PATH=$PATH:$HOME/.dotnet && dotnet publish src/XIVLauncher.Core -r linux-x64 -c Release --self-contained -o ~/xlcore-patched && cp ~/xlcore-patched/XIVLauncher.Core ~/.local/share/Steam/compatibilitytools.d/XLM/xlcore/XIVLauncher.Core
```

## FAQ

**Will this break my install?**
No. Only the patcher's error handling changed. Existing game files and config are untouched.

**Do I lose Dalamud / plugins?**
No. They live in `~/.xlcore/` and are unaffected.

**Does this work on regular Linux?**
Yes. Build with `dotnet publish src/XIVLauncher.Core -r linux-x64 -c Release --self-contained`.

**How do I revert?**
Delete `~/xlcore-patched/` and `~/XIVLauncher.Core/`. XLM restores the official binary on its next update.
