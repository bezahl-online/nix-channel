let
  # Import sources
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs { };
  
  # Import your packages
  ptapi = import ./ptapi { inherit pkgs; };
  RFID = import ./RFID { inherit pkgs; };
# And return that specific nixpkgs
in  {
  inherit ptapi RFID;
}
