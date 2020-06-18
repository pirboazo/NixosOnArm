{ config, pkgs, lib,  ...} :

{
#
# NixOS wants to enable GRUB by default
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;
#
# if you have a Raspberry Pi 2 or 3), pick this:
  boot.kernelPackages = pkgs.linuxPackages_4_19;
  nixpkgs.config.allowUnsupportedSystem = true; 

# If X.org behaves weirdly (I only saw the cursor) then try increasing this to 256M.
  # On a Raspberry Pi 4 with 4 GB, you should either disable this parameter or increase to at least 64M if you want the USB ports to work.
  boot.kernelParams = lib.mkForce [
     "console=ttyS1,115200n8"
     "console=tty1"
     "loglevel=7"
     "cma=256M"
  ];

  networking.hostName = "rpi3-Nixos"; # Define your hostname.

# File systems configuration for using the installer's partition layout
  fileSystems = {
    # Prior to 19.09, the boot partition was hosted on the smaller first partition
    # Starting with 19.09, the /boot folder is on the main bigger partition.
    # The following is to be used only with older images.
    #
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  };

# disable documentation.
  documentation.nixos.enable= false;
  documentation.man.enable= true;
  documentation.doc.enable= false;

# Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.forwardX11 = true;
  programs.ssh.forwardX11 = true;

 # Enable the X11 windowing system.
   services.xserver.enable = true;
   services.xserver.layout = "ch";
   services.xserver.xkbVariant = "fr";
   services.xserver.xkbOptions = "eurosign:e";
   services.xserver.videoDrivers = [ "fbdev" ] ;

  # Enable the gnome3 Desktop Environment.
   services.xserver.displayManager.sddm.enable = true;
   services.xserver.desktopManager.mate.enable = true;

# enable zramswap
zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

# Set your time zone.
  time.timeZone = "Europe/Zurich";
  # group
  users.groups.postgres.gid = 1100 ;

  # utisateur
  users.users.pboizot = 
  {
    isNormalUser = true;
    home = "/home/pboizot";
    description = "pierre test";
    extraGroups = [ "wheel" "networkmanager" ];
  };
  environment.systemPackages = with pkgs; [ wget bat vim lshw pciutils banner usbutils midori htop tmux ];
}
