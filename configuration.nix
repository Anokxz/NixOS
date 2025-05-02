{ config, lib, pkgs, ... }: {

  imports = [
    ./hardware-configuration.nix
    #./nginx-config.nix # Need Some Fixs
  ];

  # Bootloader setup
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  # Hostname and networking setup
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  
  # Static IP for ethernet
  networking.interfaces.enp0s13.ipv4.addresses = [ {
    address = "192.168.1.48";
    prefixLength = 24;
  } ];
  
  networking.defaultGateway = "192.168.1.1";
  networking.nameservers = [ 
    "8.8.8.8" 
    "8.8.4.4" 
  ];

  # Timezone and locale
  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_US.UTF-8";

  # Sound: Using PipeWire (ensure PulseAudio is disabled)
  hardware.pulseaudio.enable = false;
  services.pipewire.enable = true;
  services.pipewire.pulse.enable = true;

  # User account setup
  users.users.anokxz = {
     isNormalUser = true;
     extraGroups = [ "wheel" "docker" ];
     password = "$6$MmO.jwILk7NO3FC2$5jH8ft4tzFs0i34YzzYSI8veJV8703DfIweXCHrsUX/9pSBAHX/ZIq.SaQcYonJENqhGmkZ6aZc2KyW2lX9sZ0"; # hashed password
   };

  # System packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    htop
    btop
    neofetch
    python3
    gcc
    neovim 
    xorg.xrandr
    git
 
    ];

  # SSH service
  services.openssh.enable = true;

  # Firewall
  networking.firewall.enable = false;

  # Samba FTP Server
  services.samba = {
    enable = true;
    securityType = "user";
    openFirewall = true;
    
    settings = {
	global = {
	  "workgroup" = "WORKGROUP";
     	  "server string" = "smbnix";
	  "netbios name" = "NIXOS";
      	  "security" = "user";
	  "hosts allow" = "0.0.0.0/0";
          "guest account" = "nobody";
    	  "map to guest" = "bad user";
	};

    	"public" = {
      	  "path" = "/home/anokxz/samba-public";
      	  "browseable" = "yes";
          "read only" = "no";
          "guest ok" = "yes";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = "anokxz";
          "force group" = "users";
    	};

    	"private" = {
          "path" = "/home/anokxz/samba-private";
	  "browseable" = "yes";      
	  "read only" = "no";
      	  "guest ok" = "no";
      	  "create mask" = "0644";
      	  "directory mask" = "0755";
      	  "force user" = "anokxz";
      	  "force group" = "users";
    	};
      };
    };
  
  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  # Docker Service 
  virtualisation.docker.enable = true;
  
  # Configure Kubernetes (but disabled)
#  services.kubernetes = {
 #   roles = [ "master" "node" ];
  #  kubelet.enable = false;
   # masterAddress = "127.0.0.1";
#    clusterAdmin = "root";
 #   apiserver.enable = false;
  #  controllerManager.enable = false;
   # scheduler.enable = false;
#    proxy.enable = false;
 #   addons.dns.enable = false;
#  };

  # Configure Jellyfin
  services.jellyfin = {
    enable = false;
  };

  # Copy system config
  system.copySystemConfiguration = true;
 
  # NixOS state version
  system.stateVersion = "24.11";
}
