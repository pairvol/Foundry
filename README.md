# Foundry

A one-place installer for pairvol's native apps (GJS + GTK4, same dark
"Default Dark" palette as `pv-term`/`nce-gui`/Wraith/VoidScribe) -- browse
what's available, see what's already installed, install what isn't.
Long-term this is meant to grow into a full distro-wide app store; for now
it covers five entries: VoidScribe, Wraith, Native Code Editor, NullWire,
and Spotify.

**Status: mostly mockup, one real install path.** The UI is fully
functional (it correctly detects what's already installed and can launch
it). For the four pairvol apps, clicking Install shows a placeholder
dialog -- their install needs a git clone + build step, not done yet. For
Spotify, Install is wired up for real: it has an official snap, so the
whole install is one command (`pkexec snap install spotify`), used here
as an end-to-end proof that Foundry's install flow (privilege prompt,
async run, button state, error handling) actually works before the harder
clone-and-build path gets built for the others.

## Run

```sh
./bin/foundry
```

## Install As A Desktop App

```sh
make install
```

Installs `~/.local/bin/foundry` and a desktop entry
(`dev.pairvol.Foundry.desktop`). Run `make uninstall` to remove it.

## Requirements

GTK4 and `gjs`. On Ubuntu/Ubuntu Cinnamon:

```sh
curl -fsSL https://raw.githubusercontent.com/pairvol/Foundry/main/install-foundry.sh | bash
```

## How it works today

Each entry in `bin/foundry`'s `APPS` list is one of two kinds:

- **`kind: 'pairvol'`** (VoidScribe, Wraith, Native Code Editor, NullWire)
  -- detected via whether `~/.local/share/applications/<desktopId>.desktop`
  exists. Installed -> "Open" button, launches via `Gio.DesktopAppInfo`.
  Not installed -> "Install" button shows a "not wired up yet" dialog;
  `source` is informational only for these right now.
- **`kind: 'snap'`** (Spotify) -- detected via whether `checkCommand` is on
  `PATH` (`GLib.find_program_in_path`). Installed -> "Open" launches it
  directly. Not installed -> "Install" actually runs `installArgs`
  (`pkexec snap install spotify`) asynchronously, disables the button and
  shows "Installing…" while it runs, then re-checks install state on
  success or shows the real error output on failure/cancellation. The
  password/authentication prompt is the desktop's own polkit dialog, not
  anything Foundry draws.

## Planned Features

- Real install actions for the four pairvol apps: clone from each app's
  GitHub repo, build, and run its own `install-*.sh` (which already exist
  for VoidScribe, Wraith, and Native Code Editor) rather than
  reimplementing install logic here
- Install progress/output shown in the UI instead of just a final
  success/error dialog
- Update detection (repo has commits ahead of what's installed, or a snap
  refresh is available) and an "Update" action alongside Install/Open
- Uninstall action
- Custom Foundry icon (currently falls back to the generic
  `applications-system` stock icon)
- Broaden scope beyond these five entries to a real distro-wide app store

## License

MIT. See [LICENSE](LICENSE).
