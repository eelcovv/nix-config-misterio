{pkgs, ...}: {
  imports = [
    ./global
    ./features/desktop/gnome
    ./features/desktop/hyprland
    ./features/desktop/wireless
    ./features/productivity
    ./features/pass
    ./features/games
  ];

  # Purple
  wallpaper = pkgs.wallpapers.aenami-lost-in-between;

  monitors = [
    {
      name = "eDP-1";
      width = 2560;
      height = 1600;
      workspace = "1";
      primary = true;
    }
  ];
}
