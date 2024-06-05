# This is a modified hardware-configuration.nix file which contains everything
# needed for NixOS to *either* boot as a VM or boot on the physical hardware.

# The way this works is that on Windows I use a Hyper-V feature which allows
# passing through an entire physical disk to the VM. This is then used as the
# boot device.

# WARNING: Do not use the equivalent VirtualBox feature. It will randomly
# destroy the VM's filesystem.

{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  # from vendored hyperv-guest.nix
  virtualisation.mxHypervGuest = {
    enable = true;
    videoMode = "1920x1080";
  };

  networking.hostName = "mx-hyb-nixos";

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  # Made available and loaded if needed
  boot.initrd.availableKernelModules = [
    # From generated config on physical hardware.
    "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "sr_mod"
  ];
  # Always loaded
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/98b80480-d0d8-4950-b78b-a798de97cfda";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/5A07-540B";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  swapDevices = [ ];
  # No swap. Disable systemd-oomd (as I had errors on nixos-rebuild)
  systemd.services.oomd.enable = false;

  # Enables DHCP on each ethernet and wireless interface. In case of scripted
  # networking (the default) this is the recommended approach. When using
  # systemd-networkd it's still possible to use this option, but it's
  # recommended to use it in conjunction with explicit per-interface
  # declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp34s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp3s0f0u2u3c2.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp37s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
