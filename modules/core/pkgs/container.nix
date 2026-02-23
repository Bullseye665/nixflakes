{ pkgs, ... }:
{
   environment.systemPackages = with pkgs; [
    nano
    toybox
  ];
}
