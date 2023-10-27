# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "gk999999"; # Define your hostname.

  networking.networkmanager.enable =
    true; # Easiest to use and most distros use this by default.

  time.timeZone = "Europe/Vienna";
  i18n.defaultLocale = "de_AT.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "de";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  systemd.services.printapi = {
    ServiceConfig = {
      Environment = "PRODUCTIVE=YES";
      Environment =
        "INVOICE_PDF_URL=https://rksv.greisslomat.at/invoice_pdf?code=";

      Type = simple;
      User = kassa;
      WorkingDirectory = /home/kassa;
      ExecStart = (pkgs.callPackage ../printapi/default.nix { }).outPath
      + "/bin/printapi";;
      Restart = on-failure;
      RestartSec = 5;
      StartLimitAction = reboot;
    };
  };

  services.cage = {
    enable = true;
    user = "kassa";
    extraArguments = [ "-r" "-r" "-r" ];
    program = (pkgs.callPackage ../register-tauri/default.nix { }).outPath
      + "/bin/register";
  };

  services.xserver.layout = "de";

  services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  users.users.kassa = {
    isNormalUser = true;
    extraGroups = [ "dialout" "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [ ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [ vim wget joe ];

  services.openssh.enable = true;

  system.stateVersion = "23.05"; # Did you read the comment?

}
