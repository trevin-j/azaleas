# 🌺 Azaleas 🌺  

Azaleas (from "z alias") is a **lightweight, modular alias framework** for Zsh.  

## Why Use an Alias Framework?  

Well... maybe you don't need one. And that's cool. Thanks for checking out the repo anyway!  

However, if you want:  
✅ A **declarative way** to manage and load aliases effortlessly.  
✅ **Conditional aliases** that apply only if certain commands are installed (e.g., replace `ls` with `exa` only if `exa` is installed).  
✅ A **cleaner, more modular setup** for aliases instead of cluttering your `.zshrc`.  

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

---

## Features  

🌱 **Modular & Organized** – Keep aliases in separate files instead of cramming them into `.zshrc`.  
🔀 **Conditional Aliases** – Define aliases that only apply if required dependencies are installed.  
📂 **XDG-Compliant** – Uses `~/.config/azaleas/` or your custom `XDG_CONFIG_HOME` for clean organization.  
🔧 **Easily Extendable** – Add, modify, or remove aliases without touching `.zshrc`.  

---

## Usage  

Once installed, Azaleas creates an **aliases directory** at:  

```sh
~/.config/azaleas/aliases/
```

This can be overridden by setting `XDG_CONFIG_HOME`.  

To add aliases, simply create `.zsh` files inside `~/.config/azaleas/aliases/`.  

### Example: Creating an Alias File  

Create a file named `git.zsh` inside `~/.config/azaleas/aliases/`:  

```zsh
typeset -A ALIAS_REGISTRY=(
  g   "git"
  ga  "git add"
  gc  "git commit -m"
  gp  "git push"
)

register_aliases git
```

This ensures the aliases are **only** loaded if `git` is installed!  

### Example: Unconditional Aliases  

If an alias doesn’t depend on any command, just omit the command in the register_aliases call:  

```zsh
typeset -A ALIAS_REGISTRY=(
  cls "clear"
  grep "grep --color=auto"
)

register_aliases
```

### Reloading Aliases  

To apply new aliases without restarting your shell, run:  

```zsh
source ~/.zshrc
```

---

## Future Features  

🚀 **Importing Existing Azaleas Aliases** – Easily share and import alias sets from other users.  
📂 **Importing Regular Alias Files** – Convert traditional alias files into the Azaleas format.  
⚙️ **Interactive Alias Management** – A command to list, enable, or disable aliases dynamically.  
⚖️ **Alias Prioritization** – Set priorities for aliases to control conflict resolution when multiple aliases target the same command.  

---

## Contributing  

Contributions are welcome! Feel free to open an issue or PR if you have suggestions.  

---

## License  

Azaleas is licensed under the **MIT License**.  
