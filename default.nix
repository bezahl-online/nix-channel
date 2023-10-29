let
  # Import sources
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs { };

  ptapi = pkgs.callPackage ./ptapi { };
  RFID = pkgs.callPackage ./RFID { };
  printapi = pkgs.callPackage ./printapi { };
  gm65 = pkgs.callPackage ./gm65 { };
  register = pkgs.callPackage ./register-tauri { };

in {
  inherit ptapi rfid printapi gm65 register;
}
