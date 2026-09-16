# Insomnia for Noctalia v5

## Acknowledgement

Insomnia is based on [8bury/noctalia-lid-guard](https://github.com/8bury/noctalia-lid-guard)
but with the intent to inhibit sleep on any computer not just laptops and adding
more granular controls of the behavior in the future.

## Description

Insomnia adds a toggle to the Noctalia bar that keeps the computer awake. It is
useful for long-running tasks and other background jobs that needs the computer
to stay awake but doesn't care if the screen turns of or the session is locked.

The plugin uses a user-level `systemd-inhibit` lock for `sleep`. It does not
edit `logind.conf`, require root access, or disable normal idle behavior that is
not sleep/suspend meaning your computer will still lock when Noctalias normal
Lock & Suspend is called but not suspend after.

## Requirements

- Noctalia v5
- systemctl
- systemd-run
- systemd-inhibit
- sleep

## Features

- One-click bar toggle
- Active, inactive, busy, and error states
- Optional Control Center shortcut
- State detection survives Noctalia reloads while the inhibitor unit is active
- No permanent system configuration changes

## Install

Add this repository as a plugin source and enable Insomnia:

```sh
noctalia msg plugins source add insomnia git https://github.com/gronsak/noctalia-plugins.git
noctalia msg plugins enable gronsak/insomnia
```

Then add the `insomnia` widget to a bar in Noctalia settings. Left-click toggles
the mode; right-click refreshes its detected state.

## How it works

When enabled, Insomnia starts this transient user service:

```sh
systemd-run --user --unit=noctalia-insomnia.service \
  systemd-inhibit --what=handle-lid-switch --mode=block sleep infinity
```

Turning the mode off stops the service and removes the inhibitor. The mode is
off after logging out or rebooting.

To disable it manually if Noctalia is unavailable:

```sh
systemctl --user stop noctalia-insomnia.service
```

## License

MIT
