{ config, pkgs, username, ... }:
{
  environment.systemPackages = with pkgs; [
   # python312
    wget
  ];

  home-manager.users.${username} = {
    programs.git = {
      enable = true;
#      userName = "Bullseye665";
#      userEmail = "caleb.comstock6@gmail.com";
    };
  };
}
