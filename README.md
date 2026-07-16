# Lid Guard for Noctalia v5

Lid Guard adds a toggle to the Noctalia bar that keeps a laptop awake when its
lid is closed. It is useful for long-running AI agents, builds, downloads, and
other background jobs that should continue while the display is physically
closed.

The plugin uses a user-level `systemd-inhibit` lock for
`handle-lid-switch`. It does not edit `logind.conf`, require root access, or
disable normal idle suspension.

## Features

- One-click bar toggle
- Active, inactive, busy, and error states
- Optional Control Center shortcut
- Portuguese (Brazil) and English translations
- State detection survives Noctalia reloads while the inhibitor unit is active
- No permanent system configuration changes

## Install

Add this repository as a plugin source and enable Lid Guard:

```sh
noctalia msg plugins source add lid-guard git https://github.com/8bury/noctalia-lid-guard.git
noctalia msg plugins enable 8bury/lid-guard
```

Then add the `lid-guard` widget to a bar in Noctalia settings. Left-click toggles
the mode; right-click refreshes its detected state.

## How it works

When enabled, Lid Guard starts this transient user service:

```sh
systemd-run --user --unit=noctalia-lid-guard.service \
  systemd-inhibit --what=handle-lid-switch --mode=block sleep infinity
```

Turning the mode off stops the service and removes the inhibitor. The mode is
off after logging out or rebooting.

To disable it manually if Noctalia is unavailable:

```sh
systemctl --user stop noctalia-lid-guard.service
```

## Requirements

- Noctalia v5
- systemd with `systemd-logind`

## License

MIT
