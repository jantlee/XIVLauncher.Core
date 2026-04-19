# Patch Retry Tweak

Adds per-patch retry to `PatchManager.cs`. Failed hash checks retry up to 3 times instead of aborting all downloads.

## Install (SteamOS)

```bash
cd ~ && curl -sSL https://raw.githubusercontent.com/jantlee/XIVLauncher.Core/patch-retry/install.sh | bash
```

Re-run after XLM updates.
