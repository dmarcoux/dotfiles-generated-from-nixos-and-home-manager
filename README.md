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
