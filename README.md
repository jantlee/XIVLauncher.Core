# XIVLauncher.Core - Patch Retry Fork

Personal fork of [XIVLauncher.Core](https://github.com/goatcorp/XIVLauncher.Core). One change: the patcher retries failed patches instead of aborting everything.

## What changed

`PatchManager.cs`: failed hash checks retry up to 3 times with a 2.5s delay. Other downloads continue. Fatal error only after retries are exhausted.

## Install (SteamOS)

```bash
cd ~ && curl -sSL https://raw.githubusercontent.com/jantlee/XIVLauncher.Core/patch-retry/install.sh | bash
```

XLM updates will overwrite the patched binary. Re-run the script to reinstall.
