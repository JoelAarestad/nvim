# Neovim config

An IDE-style Neovim setup for C, C++ and Rust:

- **Layout**: file tree on the left and a terminal at the bottom, opened automatically
- **Code intelligence (LSP)**: clangd for C/C++ (installed automatically), rust-analyzer for Rust
- **Autocompletion** with snippets, plus **GitHub Copilot**
- **Debugger** with breakpoints, stepping and a variables/stack UI (LLDB)
- **Treesitter** syntax highlighting, indentation and code folding
- **Telescope** fuzzy finder, **gruvbox** colors, **lualine** status line
- **No Nerd Font needed**: icons are plain emoji/Unicode

Plugins are managed by [lazy.nvim](https://lazy.folke.io), which installs everything on first start.

## 1. Requirements

**Neovim 0.11 or newer** (0.12 recommended). Check with `nvim --version`. To install the latest release:

```bash
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim-linux-x86_64
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
echo 'export PATH="/opt/nvim-linux-x86_64/bin:$PATH"' >> ~/.bashrc   # or ~/.zshrc; then open a new terminal
```

**System tools** (git, a C compiler, ripgrep for text search, a clipboard tool, lldb for debugging):

```bash
# Ubuntu / Debian
sudo apt install git build-essential curl unzip tar ripgrep xclip lldb
# Fedora
sudo dnf install git gcc make curl unzip tar ripgrep xclip lldb
# Arch
sudo pacman -S --needed git base-devel curl unzip tar ripgrep xclip lldb
```

On Wayland, use `wl-clipboard` instead of `xclip`.

**Rust** (only if you write Rust): `rustup component add rust-analyzer`

**Node.js 22 or newer** (for Copilot). Check with `node --version`. Distro packages are often too old;
[nvm](https://github.com/nvm-sh/nvm) installs a current one:

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.8/install.sh | bash
# open a new terminal, then:
nvm install 22
```

**Neovim 0.12 only: the tree-sitter CLI** (version 0.26.1 or newer), which compiles the syntax parsers.
Install it with `cargo install --locked tree-sitter-cli`, or download the binary:

```bash
mkdir -p ~/.local/bin
curl -L https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-linux-x64.gz | gunzip > ~/.local/bin/tree-sitter
chmod +x ~/.local/bin/tree-sitter   # make sure ~/.local/bin is on your PATH
```

## 2. Install

**Fresh install:**

```bash
mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null   # back up an existing config, if any
git clone https://github.com/JoelAarestad/nvim ~/.config/nvim
nvim
```

**Upgrading from the old packer.nvim version of this config:**

```bash
cd ~/.config/nvim
git checkout -- plugin/packer_compiled.lua   # discard the generated packer file
git pull
rm -rf ~/.local/share/nvim/site/pack/packer ~/.cache/nvim/packer_hererocks   # old plugins
nvim
```

Your Mason-installed servers and your Copilot sign-in are kept.

**First start:** lazy.nvim opens a window and installs all plugins; press `q` when it's done. In the background,
Mason installs clangd and Treesitter compiles its parsers. Give it a minute, then restart Neovim. After that:

- Run `:Copilot setup` once to sign in to GitHub Copilot.
- Run `:checkhealth` if something doesn't work; it lists what's missing.

## 3. Keymaps

The leader key is **Space**.

| Keys | Action |
| --- | --- |
| `Space w` | Save file |
| `Space q` | Quit |
| `Space n` | Toggle the file tree |
| `Space t` or `Ctrl-\` | Toggle the terminal |
| `Esc` (in the terminal) | Leave terminal mode; press `i` to type in it again |

**Finding things** (Telescope)

| Keys | Action |
| --- | --- |
| `Space ff` | Find files |
| `Space fg` | Search text in all files |
| `Space fb` | Switch between open files |
| `Space fh` | Search Neovim's help |

**Code** (when a language server is running)

| Keys | Action |
| --- | --- |
| `gd` / `gD` | Go to definition / declaration |
| `K` | Show documentation |
| `grr` | List references |
| `Space rn` (or `grn`) | Rename symbol |
| `Space ca` (or `gra`) | Code actions (quick fixes) |
| `Space cf` | Format file |
| `Space e` | Show errors for the current line |
| `[d` / `]d` | Previous / next error |

**Completion**

| Keys | Action |
| --- | --- |
| `Ctrl-n` / `Ctrl-p` | Next / previous suggestion |
| `Enter` | Accept the selected suggestion |
| `Ctrl-Space` / `Ctrl-e` | Open / close the menu |
| `Ctrl-f` / `Ctrl-b` | Scroll the documentation |
| `Ctrl-l` / `Ctrl-h` | Jump to the next / previous snippet field |
| `Tab` | Accept the Copilot suggestion |

**Debugging**

| Keys | Action |
| --- | --- |
| `F5` | Start / continue |
| `F6` / `F7` / `F8` | Step over / into / out |
| `Space b` | Toggle breakpoint |
| `Space B` | Breakpoint with a condition |
| `Space du` | Show / hide the debugger UI |
| `Space dt` | Stop debugging |
| `Space dr` / `Space dl` | Open the debug console / re-run the last session |

- **C/C++**: compile with debug info (`gcc -g -O0 main.c -o main`), set a breakpoint, press `F5` and enter the
  path to the executable.
- **Rust**: in a Cargo project, press `F5` and pick a target (it's built for you), or run `:RustLsp debuggables`.

**Folding and selection**

- `za` toggle a fold, `zc` close, `zo` open, `zM` close all, `zR` open all.
- Select by syntax: on Neovim 0.12 press `v`, then `an` to grow the selection and `in` to shrink it.
  On 0.11: `gnn` to start, `grn` to grow, `grm` to shrink.

## 4. Customizing

| File | What's in it |
| --- | --- |
| `init.lua` | Entry point |
| `lua/config/options.lua` | Editor settings (tabs, line numbers, folding, clipboard) |
| `lua/config/keymaps.lua` | General keymaps |
| `lua/config/autocmds.lua` | Startup layout (tree + terminal) |
| `lua/plugins/*.lua` | One file per plugin, including its keymaps |

- **More languages**: add the name to `parsers` in `lua/plugins/treesitter.lua`, and install a language
  server with `:Mason` (for example `pyright` for Python). Servers installed through Mason start automatically.
- **Update plugins**: `:Lazy update`, then commit `lazy-lock.json` (`lazy-lock.nvim-0.11.json` on
  Neovim 0.11). If an update breaks something, `:Lazy restore` goes back to the versions in the lockfile.

## Troubleshooting

- **Icons show as boxes**: your terminal font has no emoji. Install an emoji font (e.g. `fonts-noto-color-emoji`).
- **Copying doesn't reach the system clipboard**: install `xclip` (X11) or `wl-clipboard` (Wayland).
- **"Can't install Treesitter parsers"**: install the tree-sitter CLI (see Requirements), then restart Neovim.
- **No completion or go-to-definition in C/C++**: check `:Mason` shows clangd as installed. For projects
  with a build system, clangd needs a `compile_commands.json` (CMake: `-DCMAKE_EXPORT_COMPILE_COMMANDS=ON`).
- **"No LLDB debug adapter found"**: install `lldb` with your package manager, or run `:MasonInstall codelldb`.
