# Dotfiles for EndeavourOS

1. Setup 1Password

   1. Install 1Password GUI, and CLI, then the browser extension (manually).

      ```bash
      yay 1password 1password-cli
      ```

   2. Add 1Password to autostart in KDE.

   3. Enable [1Password SSH agent](https://developer.1password.com/docs/ssh/get-started/#step-3-turn-on-the-1password-ssh-agent).

   4. [Sign Git commits with my SSH key](https://developer.1password.com/docs/ssh/git-commit-signing/).

   5. Configure the GUI and browser extension to match the settings stored in my 1Password notes.

2. Open Firefox and connect to Firefox Sync. This restores my extensions and
   settings. The linkding extension must be configured.

3. Install Neovim and xsel (clipboard tool).

   ```bash
   sudo pacman -S neovim xsel
   ```

4. Setup Git

   ```bash
   git config --global user.name "Dany Marcoux" && \
   git config --global user.email "git@dmarcoux.com" && \
   git config --global core.editor "nvim"
   ```

5. Setup Mullvad VPN

   ```bash
   yay mullvad-vpn-bin
   ```

6. Setup JetBrains Toolbox and IDEs

   1. Install JetBrains Toolbox

      ```bash
      yay jetbrains-toolbox
      ```

   2. Open the JetBrains Toolbox and log in with my account

   3. In the JetBrains Toolbox settings, disable `Launch Toolbox App at system startup`

   4. Install the IDEs I need

## TODOs

I want to track how the system is configured. This includes dotfiles and
packages. It would simplify reinstallation of my system if needed. I need this
for work, so this is important.

- Track dotfiles
- Track all official packages I've installed (`pacman -Qqe | grep -Fv -f <(pacman -Qqm)` includes the core packages from the install.. is it okay?)
- Track all AUR packages (`pacman -Qqm` lists them)
- Regularly remove unused packages (orphans) with [`pacman -Qdtq | pacman -Rns -`](https://wiki.archlinux.org/title/Pacman/Tips_and_tricks)
