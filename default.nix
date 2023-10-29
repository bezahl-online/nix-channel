let
  # Import sources
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs { };
  
  # Import your packages
  ptapi = import ./ptapi { inherit pkgs; lib };
  RFID = import ./RFID { inherit pkgs; lib };
# And return that specific nixpkgs
in  {
  inherit ptapi RFID;
}

# [ralph@blaster:~/workspace/nix-channel]$ nix-build '<mychan>' -A RFID
# error: anonymous function at /nix/store/815cnrfcvvv0fc3chrvkh252pm4najzp-mychan/mychan/RFID/default.nix:4:1 called without required argument 'lib'

#        at /nix/store/815cnrfcvvv0fc3chrvkh252pm4najzp-mychan/mychan/default.nix:8:10:

#             7|   ptapi = import ./ptapi { inherit pkgs; lib };
#             8|   RFID = import ./RFID { inherit pkgs; lib };
#              |          ^
#             9| # And return that specific nixpkgs
# In this case, the issue you are encountering is due to the missing required argument 'lib' in your RFID Nix package. When you are importing the RFID package in your Nix expression, you are only passing the 'pkgs' package set to it. As a result, the 'lib' attribute is missing and that's why you are seeing the error.

# To solve this issue, you should pass the 'lib' attribute to the RFID package. The 'lib' attribute is typically part of the 'pkgs' attribute set, so you can make it available by using the 'inherit' keyword:

# ```nix
# RFID = import ./RFID { inherit (pkgs) lib; };
# ```

# Another variant is to pass the whole 'pkgs' set but I would advise against this approach unless your package really requires the entire set. Here is how you can do it:

# ```nix
# RFID = import ./RFID { inherit pkgs; };
# ```

# And in your 'RFID/default.nix' file you should then be able to use 'pkgs.lib' to access the library functions.

# Please adjust the code according to your need. If RFID depends on more attributes/packages, you need to pass those as well in a similar way.

# Also please note that Nix syntax requires that spaces are placed around the equals sign, but not inside the braces formally used for referencing a variable.
