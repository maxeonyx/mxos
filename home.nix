{ pkgs, ... }: {
  imports = [
    ./home/fish.nix
    ./home/git.nix
  ];

  home = {
    username = "maxeonyx";
    homeDirectory = "/home/maxeonyx";
  };

  programs = {
    firefox.enable = true;
  };

  home.packages = [
    pkgs.tree
  ];

  gtk = {
    enable = true;
    iconTheme = {
      name = "Numix-Circle";
      package = pkgs.numix-icon-theme-circle;
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
