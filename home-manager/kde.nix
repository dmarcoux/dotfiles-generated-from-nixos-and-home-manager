{
  # Configure KDE with plasma-manager
  programs.plasma = {
    enable = true;

    # Start with a "clean" / empty session; no applications from the previous session is restored
    session.sessionRestore.restoreOpenApplicationsOnLogin = "startWithEmptySession";

    kwin = {
      # Enable and configure blue light filter to make the screen warmer based on location and time
      nightLight = {
        enable = true;

        # Use coordinates to figure out the sunset/sunrise times for the location defined below
        mode = "location";

        # Freiburg im Breisgau, DE
        # TODO: Check if this is needed. Maybe not setting this would automatically pick up the location.
        location = {
          latitude = "47.9990";
          longitude = "7.8421";
        };

        # Colour temperature to use at day/night, between 1000 and 25000 K
        temperature = {
          day = 5500;
          night = 3500;
        };
      };
    };

    hotkeys.commands."launch-terminal" = {
      name = "Launch terminal";
      key = "Meta+Enter";
      command = "alacritty";
    };

    # See the shortcuts in `System Settings - Shortcuts`
    #
    # If somehow a shortcut configured below isn't applied/working, it must be clashing with a default shortcut for a given action.
    # Fix this by setting the given action to an empty string, thus unbinding the shortcut.
    shortcuts = {
      # Session Management
      ksmserver = {
        "Lock Session" = [
          "Screensaver"
          "Meta+Shift+C"
        ];
      };

      kwin = {
        "Switch to Desktop 1" = "Meta+1";
        "Activate Task Manager Entry 1" = "";
        "Switch to Desktop 2" = "Meta+2";
        "Activate Task Manager Entry 2" = "";
        "Switch to Desktop 3" = "Meta+3";
        "Activate Task Manager Entry 3" = "";
        "Switch to Desktop 4" = "Meta+4";
        "Activate Task Manager Entry 4" = "";
        "Switch to Desktop 5" = "Meta+5";
        "Activate Task Manager Entry 5" = "";
        "Window to Desktop 1" = "Meta+!"; # Meta+Shift+1 on my keyboard layout
        "Window to Desktop 2" = "Meta+@"; # Meta+Shift+2 on my keyboard layout
        "Window to Desktop 3" = "Meta+#"; # Meta+Shift+3 on my keyboard layout
        "Window to Desktop 4" = "Meta+$"; # Meta+Shift+4 on my keyboard layout
        "Window to Desktop 5" = "Meta+%"; # Meta+Shift+5 on my keyboard layout
        "Switch to Window Below" = "Meta+J";
        "Switch to Window to the Left" = "Meta+H";
        "Switch to Window to the Right" = "Meta+L";
        "Switch to Window Above" = "Meta+K";
        "Switch Window Down" = "Meta+Shift+J";
        "Switch Window Left" = "Meta+Shift+H";
        "Switch Window Right" = "Meta+Shift+L";
        "Switch Window Up" = "Meta+Shift+K";
        "Expose" = "Meta+,";
      };
    };
  };
}
