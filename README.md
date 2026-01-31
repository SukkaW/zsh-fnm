# zsh-fnm

An [`oh-my-zsh`](https://ohmyz.sh/) plugin that provides enhancement to the Node.js version manager [`fnm`](https://fnm.vercel.app).

## Features

- Delete fnm's per-session symlinks (`$FNM_MULTISHELL_PATH`) after shell exit to avoid dangling symlinks.
- Add `fnm upgrade [MAJOR]` command to upgrade installed Node.js major versions to their latest versions.

## Installation

### oh-my-zsh

1. Clone this repository into `$ZSH_CUSTOM/plugins` (by default `~/.oh-my-zsh/custom/plugins`)

```bash
git clone https://github.com/sukkaw/zsh-fnm ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-fnm
```

2. Add the plugin to the list of plugins for oh-my-zsh to load (inside `~/.zshrc`):

```
plugins=(
    [plugins
     ...]
    zsh-fnm
)
```

3. Append `zsh_fnm` to the end of your `.zshrc` (or anywhere after your fnm is already initialized) to initialize this plugin:

```bash
zsh_fnm
```

4. Start a new terminal session.

### Antigen

[Antigen](https://github.com/zsh-users/antigen) is a zsh plugin manager, and it support `oh-my-zsh` plugin as well. You only need to add `antigen bundle sukkaw/zsh-fnm` to your `.zshrc` with your other bundle commands if you are using Antigen. Antigen will handle cloning the plugin for you automatically the next time you start zsh. You can also add the plugin to a running zsh with `antigen bundle sukkaw/zsh-fnm` for testing before adding it to your `.zshrc`.

## Usage

```bash
fnm upgrade help
```

## License

[MIT](LICENSE)

------

**zsh-fnm** © [Sukka](https://github.com/SukkaW), Authored and maintained by Sukka with help from contributors ([list](https://github.com/SukkaW/zsh-fnm/graphs/contributors)).

> [Personal Website](https://skk.moe) · [Blog](https://blog.skk.moe) · GitHub [@SukkaW](https://github.com/SukkaW) · Telegram Channel [@SukkaChannel](https://t.me/SukkaChannel) · Twitter [@isukkaw](https://twitter.com/isukkaw) · Mastodon [@sukka@acg.mn](https://acg.mn/@sukka) · BlueSky [@skk.moe](https://bsky.app/profile/skk.moe)

<p align="center">
  <a href="https://github.com/sponsors/SukkaW/">
    <img src="https://sponsor.cdn.skk.moe/sponsors.svg"/>
  </a>
</p>
