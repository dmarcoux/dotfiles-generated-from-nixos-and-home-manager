{
  imports = [
    ./kde.nix
    ./lf.nix
    ./neovim.nix
    ./stylix.nix
    ./xdg.nix
  ];

  home = {
    username = "dany";
    homeDirectory = "/home/dany";

    # Switching to a higher state version typically requires performing some manual steps, such as data conversion or moving files
    # See release notes for state version changes: https://nix-community.github.io/home-manager/release-notes.html
    stateVersion = "24.11"; # Please read the comment before changing.
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
