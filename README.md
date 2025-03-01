# 🌺 Azaleas 🌺  

Azaleas (from "z alias") is a **lightweight, modular alias and init command management framework** for Zsh.  

![Zsh Compatible](https://img.shields.io/badge/shell-zsh-brightgreen) ![License](https://img.shields.io/github/license/trevin-j/Azaleas) ![Contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen) ![Zsh Plugin](https://img.shields.io/badge/zsh-plugin-blue)

## Why Use a Command & Alias Framework?  

Well... maybe you don't need one. And that's cool. Thanks for checking out the repo anyway!  

However, if you want:  
✅ A **declarative way** to manage and load aliases and shell commands effortlessly.  
✅ **Conditional execution** of aliases and commands based on installed dependencies (e.g., replace `ls` with `exa` only if `exa` is installed).  
✅ A **cleaner, more modular setup** instead of cluttering your `.zshrc`.  
✅ **Persistent one-time commands** that only run once ever (e.g., creating directories).  
✅ **Per-session commands** that run once per shell session (e.g., initializing the Starship prompt).  

Then **Azaleas** might be exactly what you need!  

---

## Installation  

To install Azaleas, simply **clone the repo** and source the plugin manually:  

```zsh
git clone https://github.com/trevin-j/azaleas.git ~/.config/azaleas
echo 'source ~/.config/azaleas/azaleas.zsh' >> ~/.zshrc
```

Or, use a **Zsh plugin manager** for automatic updates. For example, using **zcomet**:  

```zsh
zcomet load trevin-j/azaleas
```

Other plugin managers like `znap`, `antidote`, or `zinit` should work similarly.  

### Bonus: Get Reminders to Use Aliases  

To reinforce alias usage, consider using the [`zsh-you-should-use`](https://github.com/MichaelAquilina/zsh-you-should-use) plugin:  

```zsh
zcomet load MichaelAquilina/zsh-you-should-use
```

It will remind you when an alias exists for a command you typed manually, helping you form better habits!

---

## Features  

🌱 **Modular & Organized** – Keep aliases and commands in separate files instead of cramming them into `.zshrc`.  
🔀 **Conditional Execution** – Define aliases and commands that only apply if required dependencies are installed.  
📂 **XDG-Compliant** – Uses `~/.config/azaleas/` or your custom `XDG_CONFIG_HOME` for clean organization.  
🚀 **Per-Session Commands** – Run initialization commands once per shell session.  
🔄 **One-Time Commands** – Run commands only once ever (e.g., creating necessary directories).  
🔧 **Easily Extendable** – Add, modify, or remove aliases and commands effortlessly.  

---

## Usage  

Once installed, Azaleas creates a **configuration directory** at:  

```sh
~/.config/azaleas/
```

This can be overridden by setting `XDG_CONFIG_HOME`.  

To manage aliases and commands, Azaleas provides multiple methods:  

### Grouped Aliases & Commands (Recommended)  

Aliases and commands are organized into `.zsh` files inside:  

```sh
~/.config/azaleas/cfg/
```

#### Example: Creating an Alias & Command File  

Create a file named `git.zsh` inside `~/.config/azaleas/cfg/`:  

```zsh
# Define aliases that depend on git
typeset -A ALIAS_REGISTRY=(
  g   "git"
  ga  "git add"
  gc  "git commit -m"
  gp  "git push"
)

# Define init commands that depend on git
typeset -a COMMAND_REGISTRY=(
  "echo Hi I am running every time the shell opens!"
)

# Define one-time commands that depend on git
typeset -a ONCE_COMMAND_REGISTRY=(
  "mkdir -p ~/repos"
)

# Register all the commands and aliases from ALIAS_REGISTRY, COMMAND_REGISTRY, and ONCE_COMMAND_REGISTRY
azaleas_register git
```

This ensures the aliases and commands are **only** loaded if `git` is installed!  

Each file in the cfg directory looks like this. This can be done multiple times per file, for example if there are different dependency requirements in the same group. You can specify as many or as few dependencies that are needed for the commands.

### Single Aliases & Commands (For Small Additions)  

For cases where creating a whole file is overkill, you can define **single aliases and commands** like this:  

```zsh
# Each item is in the format "dependency:alias:expansion"
typeset -a SINGLES_ALIASES=(
  "exa:ls:exa --icons"   # Exa is like a better ls. But we don't want to replace the ls command
                         # if exa is not installed on our system!
  ":cls:clear"  # This example doesn't rely on any dependencies
)

typeset -a SINGLES_COMMANDS=(
  "starship:eval $(starship init zsh)"  # In order to use the starship prompt, we actually need starship installed...
)

typeset -a SINGLES_ONCE_COMMANDS=(
  "fzf:mkdir -p ~/.config/fzf"    # We only need to make the fzf config folder one time ever and only if fzf is installed.
)

azaleas_register_singles  # Ensure single aliases & commands are registered
```

- **Single Aliases:** `"dependency:alias:replacement"` (e.g., `exa:ls:exa --icons`)  
- **Single Commands:** `"dependency:command"` (e.g., `starship:eval $(starship init zsh)`)  
- **Single One-Time Commands:** `"dependency:command"` (e.g., `fzf:mkdir -p ~/.config/fzf`)  
- Omit the dependency before the first `:` to make them unconditional.  

### Resetting One-Time Commands  

If a one-time command needs to run again (e.g., recreating directories), reset it with:  

```zsh
azaleas_once_reset all   # Resets all one-time commands
azaleas_once_reset "mkdir -p ~/.config/fzf"   # Resets this specific command, it will be run again on next shell startup
```

---

## Future Features  

🚀 **Importing Existing Azaleas Configs** – Easily share and import command/alias sets from other users.  
📂 **Importing Regular Alias Files** – Convert traditional alias files into the Azaleas format.  
⚙️ **Interactive Command Management** – A command to list, enable, or disable aliases and commands dynamically.  
⚖️ **Execution Prioritization** – Set priorities for aliases to control conflict resolution.  

---

## Contributing  

Contributions are welcome! Feel free to open an issue or PR if you have suggestions.  

---

## License  

Azaleas is licensed under the **MIT License**.  

