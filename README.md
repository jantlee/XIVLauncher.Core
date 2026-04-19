# XIVLauncher.Core (Patched)

Fork of [goatcorp/XIVLauncher.Core](https://github.com/goatcorp/XIVLauncher.Core) with per-patch retry logic for the patcher. Fixes the long-standing issue where a single failed hash check cancels all concurrent downloads and requires a full restart.

## What This Fixes

The upstream patcher has no retry logic. When any single patch fails a hash check (common due to in-transit corruption from Akamai's CDN), it calls `CancelAllDownloads()` and stops everything. On fresh installs (60+ GB), this means restarting the entire patch process repeatedly until every file happens to download without corruption.

This fork adds:
- Per-patch retry (up to 3 retries per patch, 2.5s delay between attempts)
- Automatic deletion and re-download of corrupted patch files
- Other concurrent downloads continue uninterrupted when one patch fails
- Fatal failure only after all retries are exhausted

## Install (SteamOS / Steam Deck)

One command in Konsole (Desktop Mode):

```bash
cd ~ && curl -sSL https://raw.githubusercontent.com/jantlee/XIVLauncher.Core/patch-retry/install.sh | bash
```

This installs the .NET SDK (to `~/.dotnet/`), clones the repo, builds the patched binary, and outputs it to `~/xlcore-patched/`.

Then copy the patched binary over the XLM-managed one:

```bash
cp -r ~/xlcore-patched/* ~/.xlcore/
```

Launch FFXIV normally through Steam (Game Mode or Desktop Mode). XLM loads the patched binary from `~/.xlcore/`.

## Updating

If the upstream XIVLauncher.Core releases an update, XLM will overwrite your patched binary. Re-run the install script to rebuild and re-copy.

## Building Manually

```bash
git clone https://github.com/jantlee/XIVLauncher.Core.git
cd XIVLauncher.Core
git checkout patch-retry
git submodule update --init --recursive
dotnet publish src/XIVLauncher.Core -r linux-x64 -c Release --self-contained -o ~/xlcore-patched
```

Requires .NET SDK 10.0+.

## FAQ

**Q: Will this break my existing FFXIV install?**
No. The retry logic only changes how the patcher handles download failures. Successfully downloaded patches and your existing game files are untouched. If you have a partial download in progress, it picks up where it left off.

**Q: Do I lose Dalamud / plugins?**
No. Dalamud, plugins, and all config files live in `~/.xlcore/` and are not affected by replacing the launcher binary.

**Q: What happens when XLM auto-updates XIVLauncher?**
XLM will overwrite the patched binary with the official release. Re-run the install script to rebuild and copy again. Your game files and config are unaffected.

**Q: Does this work on regular Linux (not SteamOS)?**
Yes. The install script works on any Linux with `git` and `bash`. The build targets `linux-x64`.

**Q: Does this work on Windows?**
No. This fork is for XIVLauncher.Core (Linux/SteamOS). The Windows version of XIVLauncher is a separate project.

**Q: Can I use the official launcher to patch and then switch to this?**
Yes. The game files are the same regardless of which launcher downloaded them.

**Q: The install script fails with "cannot access parent directories"**
Run `cd ~` first, then re-run the script. This happens when the terminal's current directory was deleted.

**Q: How do I go back to the official XIVLauncher?**
Delete `~/xlcore-patched/` and `~/XIVLauncher.Core/`. Next time XLM updates, it restores the official binary automatically. Or force it: in Desktop Mode, launch FFXIV and XLM will re-download the official XIVLauncher.Core.

## Credits

Based on [goatcorp/XIVLauncher.Core](https://github.com/goatcorp/XIVLauncher.Core). All credit to the goatcorp team for XIVLauncher and Dalamud.
