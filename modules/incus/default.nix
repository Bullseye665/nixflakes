{ config, username, ... }:
  let
    uiAddress = "127.0.0.1";
    uiPort = 8443;
    network = "incusbr0";
    poolName = "default";
  in
{
  virtualisation.incus = {
    enable = true;
    ui.enable = true;
    preseed = {
      networks = [
        {
        # VMs and containers will have IPs in the 10.10.10.X network
        config = {
          "ipv4.address" = "192.168.0.1/24";
          "ipv4.nat" = "true";
        };
          name = network;
          type = "bridge";
        }
      ];
      # The profiles are the default settings for containers
      profiles = [
        {
        name = "default";
        devices = {
          # The network that will get attached to our container, that will use our bridge
          eth0 = {
            name = "eth0";
            network = network;
            type = "nic";
          };
          root = {
            path = "/";
            pool = poolName;
            type = "disk";
          };
        };
      }
    ];
    storage_pools = [
      {
        config.source = "/var/lib/incus/storage-pools/default";
        driver = "dir";
        name = poolName;
      }
    ];
  };
};

  networking = {
    nftables.enable = true;
    firewall = {
      trustedInterfaces = [ network ];
      allowedTCPPorts = [ uiPort ];
    };
  };

  users.users.${username} = {
    extraGroups = [
      "incus"
      "incus-admin"
    ];
  };
}
