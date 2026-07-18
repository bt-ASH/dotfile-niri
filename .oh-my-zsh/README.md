<p align="center"><img src="https://ohmyzsh.s3.amazonaws.com/omz-ansi-github.png" alt="Oh My Zsh"></p>

Oh My Zsh is an open source, community-driven framework for managing your [zsh](https://www.zsh.org/) configuration.

Sounds boring. Let's try again.

**Oh My Zsh will not make you a 10x developer...but you may feel like one.**

Once installed, your terminal shell will become the talk of the town _or your money back!_ With each keystroke in your command prompt, you'll take advantage of the hundreds of powerful plugins and beautiful themes. Strangers will come up to you in cafés and ask you, _"that is amazing! are you some sort of genius?"_

Finally, you'll begin to get the sort of attention that you have always felt you deserved. ...or maybe you'll use the time that you're saving to start flossing more often. 😬

To learn more, visit [ohmyz.sh](https://ohmyz.sh), follow [@ohmyzsh](https://twitter.com/ohmyzsh) on Twitter, and join us on [Discord](https://discord.gg/ohmyzsh).



<details>
<summary>Table of Contents</summary>

- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Basic Installation](#basic-installation)
    - [Manual inspection](#manual-inspection)
- [Using Oh My Zsh](#using-oh-my-zsh)
  - [Plugins](#plugins)
    - [Enabling Plugins](#enabling-plugins)
    - [Using Plugins](#using-plugins)
  - [Themes](#themes)
    - [Selecting a Theme](#selecting-a-theme)
  - [FAQ](#faq)
- [Advanced Topics](#advanced-topics)
  - [Advanced Installation](#advanced-installation)
    - [Custom Directory](#custom-directory)
    - [Unattended install](#unattended-install)
    - [Installing from a forked repository](#installing-from-a-forked-repository)
    - [Manual Installation](#manual-installation)
  - [Installation Problems](#installation-problems)
  - [Custom Plugins and Themes](#custom-plugins-and-themes)

</details>

## Getting Started

### Prerequisites

- A Unix-like operating system: macOS, Linux, BSD. On Windows: WSL2 is preferred, but cygwin or msys also mostly work.
- [Zsh](https://www.zsh.org) should be installed (v4.3.9 or more recent is fine but we prefer 5.0.8 and newer). If not pre-installed (run `zsh --version` to confirm), check the following wiki instructions here: [Installing ZSH](https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH)
- `curl` or `wget` should be installed
- `git` should be installed (recommended v2.4.11 or higher)

### Basic Installation

Oh My Zsh is installed by running one of the following commands in your terminal. You can install this via the command-line with either `curl`, `wget` or another similar tool.

| Method    | Command                                                                                           |
| :-------- | :------------------------------------------------------------------------------------------------ |
| **curl**  | `sh -c "$(curl -fsSL https://gitee.com/caiguang_cc/ohmyzsh/raw/master/tools/install.sh)"` |
| **wget**  | `sh -c "$(wget -O- https://gitee.com/caiguang_cc/ohmyzsh/raw/master/tools/install.sh)"`   |
| **fetch** | `sh -c "$(fetch -o - https://gitee.com/caiguang_cc/ohmyzsh/raw/master/tools/install.sh)"` |

_Note that any previous `.zshrc` will be renamed to `.zshrc.pre-oh-my-zsh`. After installation, you can move the configuration you want to preserve into the new `.zshrc`._

#### Manual inspection

It's a good idea to inspect the install script from projects you don't yet know. You can do
that by downloading the install script first, looking through it so everything looks normal,
then running it:

```sh
wget https://gitee.com/caiguang_cc/ohmyzsh/raw/master/tools/install.sh
sh install.sh
```

## Using Oh My Zsh

### Plugins

Oh My Zsh comes with a shitload of plugins for you to take advantage of. You can take a look in the [plugins](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins) directory and/or the [wiki](https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins) to see what's currently available.

#### Enabling Plugins

Once you spot a plugin (or several) that you'd like to use with Oh My Zsh, you'll need to enable them in the `.zshrc` file. You'll find the zshrc file in your `$HOME` directory. Open it with your favorite text editor and you'll see a spot to list all the plugins you want to load.

```sh
vi ~/.zshrc
```

For example, this might begin to look like this:

```sh
plugins=(
  	zsh-autosuggestions
	zsh-syntax-highlighting
  	incr
)
```

_Note that the plugins are separated by whitespace (spaces, tabs, new lines...). **Do not** use commas between them or it will break._

#### Using Plugins

Each built-in plugin includes a **README**, documenting it. This README should show the aliases (if the plugin adds any) and extra goodies that are included in that particular plugin.

### Themes

We'll admit it. Early in the Oh My Zsh world, we may have gotten a bit too theme happy. We have over one hundred and fifty themes now bundled. Most of them have [screenshots](https://github.com/ohmyzsh/ohmyzsh/wiki/Themes) on the wiki (We are working on updating this!). Check them out!

#### Selecting a Theme

_Robby's theme is the default one. It's not the fanciest one. It's not the simplest one. It's just the right one (for him)._

Once you find a theme that you'd like to use, you will need to edit the `~/.zshrc` file. You'll see an environment variable (all caps) in there that looks like:

```sh
ZSH_THEME="robbyrussell"
```

To use a different theme, simply change the value to match the name of your desired theme. For example:

```sh
ZSH_THEME="agnoster" # (this is one of the fancy ones)
# see https://github.com/ohmyzsh/ohmyzsh/wiki/Themes#agnoster
```

_Note: many themes require installing a [Powerline Font](https://github.com/powerline/fonts) or a [Nerd Font](https://github.com/ryanoasis/nerd-fonts) in order to render properly. Without them, these themes will render [weird prompt symbols](https://github.com/ohmyzsh/ohmyzsh/wiki/FAQ#i-have-a-weird-character-in-my-prompt)_

Open up a new terminal window and your prompt should look something like this:

![Agnoster theme](https://cloud.githubusercontent.com/assets/2618447/6316862/70f58fb6-ba03-11e4-82c9-c083bf9a6574.png)

In case you did not find a suitable theme for your needs, please have a look at the wiki for [more of them](https://github.com/ohmyzsh/ohmyzsh/wiki/External-themes).

If you're feeling feisty, you can let the computer select one randomly for you each time you open a new terminal window.

```sh
ZSH_THEME="random" # (...please let it be pie... please be some pie..)
```

And if you want to pick random theme from a list of your favorite themes:

```sh
ZSH_THEME_RANDOM_CANDIDATES=(
  "robbyrussell"
  "agnoster"
)
```

If you only know which themes you don't like, you can add them similarly to an ignored list:

```sh
ZSH_THEME_RANDOM_IGNORED=(pygmalion tjkirch_mod)
```

### FAQ

If you have some more questions or issues, you might find a solution in our [FAQ](https://github.com/ohmyzsh/ohmyzsh/wiki/FAQ).

## Advanced Topics

If you're the type that likes to get their hands dirty, these sections might resonate.

### Advanced Installation

Some users may want to manually install Oh My Zsh, or change the default path or other settings that
the installer accepts (these settings are also documented at the top of the install script).

#### Custom Directory

The default location is `~/.oh-my-zsh` (hidden in your home directory, you can access it with `cd ~/.oh-my-zsh`)

If you'd like to change the install directory with the `ZSH` environment variable, either by running
`export ZSH=/your/path` before installing, or by setting it before the end of the install pipeline
like this:

```sh
ZSH="$HOME/.dotfiles/oh-my-zsh" sh install.sh
```

#### Unattended install

If you're running the Oh My Zsh install script as part of an automated install, you can pass the `--unattended`
flag to the `install.sh` script. This will have the effect of not trying to change
the default shell, and it also won't run `zsh` when the installation has finished.

```sh
sh -c "$(curl -fsSL https://gitee.com/caiguang_cc/ohmyzsh/raw/master/tools/install.sh)" "" --unattended
```

#### Installing from a forked repository

The install script also accepts these variables to allow installation of a different repository:

- `REPO` (default: `ohmyzsh/ohmyzsh`): this takes the form of `owner/repository`. If you set
  this variable, the installer will look for a repository at `https://github.com/{owner}/{repository}`.

- `REMOTE` (default: `https://github.com/${REPO}.git`): this is the full URL of the git repository
  clone. You can use this setting if you want to install from a fork that is not on GitHub (GitLab,
  Bitbucket...) or if you want to clone with SSH instead of HTTPS (`git@github.com:user/project.git`).

  _NOTE: it's incompatible with setting the `REPO` variable. This setting will take precedence._

- `BRANCH` (default: `master`): you can use this setting if you want to change the default branch to be
  checked out when cloning the repository. This might be useful for testing a Pull Request, or if you
  want to use a branch other than `master`.

For example:

```sh
REPO=apjanke/oh-my-zsh BRANCH=edge sh install.sh
```

#### Manual Installation

##### 1. Clone the repository <!-- omit in toc -->

```sh
git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
```

##### 2. _Optionally_, backup your existing `~/.zshrc` file <!-- omit in toc -->

```sh
cp ~/.zshrc ~/.zshrc.orig
```

##### 3. Create a new zsh configuration file <!-- omit in toc -->

You can create a new zsh config file by copying the template that we have included for you.

```sh
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
```

##### 4. Change your default shell <!-- omit in toc -->

```sh
chsh -s $(which zsh)
```

You must log out from your user session and log back in to see this change.

##### 5. Initialize your new zsh configuration <!-- omit in toc -->

Once you open up a new terminal window, it should load zsh with Oh My Zsh's configuration.

### Installation Problems

If you have any hiccups installing, here are a few common fixes.

- You _might_ need to modify your `PATH` in `~/.zshrc` if you're not able to find some commands after switching to `oh-my-zsh`.
- If you installed manually or changed the install location, check the `ZSH` environment variable in `~/.zshrc`.

### Custom Plugins and Themes

If you want to override any of the default behaviors, just add a new file (ending in `.zsh`) in the `custom/` directory.

If you have many functions that go well together, you can put them as a `XYZ.plugin.zsh` file in the `custom/plugins/` directory and then enable this plugin.

If you would like to override the functionality of a plugin distributed with Oh My Zsh, create a plugin of the same name in the `custom/plugins/` directory and it will be loaded instead of the one in `plugins/`.