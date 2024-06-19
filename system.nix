# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, unstable, ... }:

{
  imports = [ ];

  programs = {
    # Enable fish and tmux for *all* users just in case
    tmux.enable = true;
    fish.enable = true;
  };
  users.defaultUserShell = pkgs.fish;
  users.users.maxeonyx = {
    isNormalUser = true;
    description = "Max Clarke";
    extraGroups = [ "networkmanager" "wheel" ];
    # packages = [ ]; # Done with home-manager instead.
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };
  
  environment.systemPackages = [
    pkgs.efibootmgr
  ];
  boot.plymouth = {
    enable = true;
  };
  boot.initrd.systemd.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  
  # enable gnome rdp login
  services.gnome.gnome-remote-desktop.enable = true;
  systemd.targets."graphical".wants = [ "gnome-remote-desktop.service" ];
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 3389 ];

  # Rest of this stuff is from the default installation and I don't really
  # care to touch it unless neccessary.
  networking.networkmanager.enable = true;
  time.timeZone = "Pacific/Auckland";
  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_NZ.UTF-8";
    LC_IDENTIFICATION = "en_NZ.UTF-8";
    LC_MEASUREMENT = "en_NZ.UTF-8";
    LC_MONETARY = "en_NZ.UTF-8";
    LC_NAME = "en_NZ.UTF-8";
    LC_NUMERIC = "en_NZ.UTF-8";
    LC_PAPER = "en_NZ.UTF-8";
    LC_TELEPHONE = "en_NZ.UTF-8";
    LC_TIME = "en_NZ.UTF-8";
  };
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.xkb = {
    layout = "nz";
    variant = "";
  };
  services.printing.enable = true;
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
