# Patch Retry

Adds automatic retry to the game patcher. When a patch file fails its hash check (common during large downloads due to in-transit data corruption), the patcher deletes the bad file and re-downloads it automatically instead of aborting everything.

- Up to 3 retries per patch, 2.5 second delay between attempts
- Other concurrent downloads keep running
- Only errors out after all retries fail

## Install (SteamOS)

```bash
cd ~ && curl -sSL https://raw.githubusercontent.com/jantlee/XIVLauncher.Core/patch-retry/install.sh | bash
```

## FAQ

**Does this affect my existing game files?**
No. Only the patcher's error handling changed.

**What about plugins and config?**
Unaffected. They live in a different location.

**XLM updated and my patch is gone.**
Re-run the install script.

**The install script fails with "cannot access parent directories."**
Run `cd ~` first, then re-run.
