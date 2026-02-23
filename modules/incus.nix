{ pkgs, xlibre-overlay, ... }: {
  imports = [
  xlibre-overlay.nixosModules.overlay-xlibre-xserver
  xlibre-overlay.nixosModules.overlay-all-xlibre-drivers
#  ./apps
  ./core/boot/systemd.nix
  ./core/nix
  ./core/pkgs/container.nix
  ./core/security/agenix
  ./core/security/nginx
#  ./core/security/ssh
#  ./core/security/tailscale
#  ./core/security/nfs/server.nix
  ./garbage
#  ./hardware
#  ./hardware/graphics/intel
#  ./hardware/graphics/nvidia/1080.nix
  ./incus
  ];
}
