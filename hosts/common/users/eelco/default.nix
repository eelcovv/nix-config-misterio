{
  pkgs,
  config,
  lib,
  ...
}: let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  users.mutableUsers = false;
  users.users.eelco = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = ifTheyExist [
      "audio"
      "deluge"
      "docker"
      "git"
      "i2c"
      "libvirtd"
      "lxd"
      "minecraft"
      "mysql"
      "network"
      "plugdev"
      "podman"
      "video"
      "wheel"
      "wireshark"
    ];
    hashedPassword = "$y$j9T$XaNnfYFXEi2ToJvFdtQl90$HHAYVvopFFCHR.zJA7Ips4GAl7b6FdNTkGul3lUFwO8";
    # 
    #openssh.authorizedKeys.keys = lib.splitString "\n" (builtins.readFile ../../../../home/eelco/ssh.pub);
    #hashedPasswordFile = config.sops.secrets.eelco-password.path;
    packages = [pkgs.home-manager];
  };

  #sops.secrets.eelco-password = {
  #  sopsFile = ../../secrets.yaml;
  #  neededForUsers = true;
  #};

  home-manager.users.eelco = import ../../../../home/eelco/${config.networking.hostName}.nix;

  security.pam.services = {
    swaylock = {};
  };
}
