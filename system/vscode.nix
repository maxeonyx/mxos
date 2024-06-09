{ config, pkgs, unstable, ... }:

{
  # misleading name. Enable vscode server *patching* (patch node binary to work on nixos when vscode remote development installs a server)
  # this functionality comes from a flake.
  services.vscode-server.enable = true;
  
  environment.systemPackages = [
    # add vscode locally.
    unstable.vscode.fhs
  ];
}
