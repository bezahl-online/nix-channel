# build using 
# nix-build -E 'let pkgs = import <nixpkgs> { }; in pkgs.callPackage ./default.nix {}'
#
{ lib
, buildGoModule
, fetchFromGitHub
, nixosTests
, testers
, installShellFiles
}:
let
  version = "1.0.1";
  owner = "bezahl-online";
  pname = "rfidserver";
  repo = "RFID";
  rev = "v${version}";
  sha256 = "1ikyp1rxrl8lyfbll501f13yir1axighnr8x3ji3qzwin6i3w497";
in
buildGoModule {
  inherit version pname repo;

  src = fetchFromGitHub {
    owner = "bezahl-online";
    repo = repo;
    rev = "174899d4c6f945a97ffc7ba782603bf1abae1463";
    sha256 = "sha256-LTkuBYTH7v6Y9LXRNKN0CmiCjbHnDMUqxSTG5AK80Gw=";
  };
  # src = ../RFID/.;
 
  vendorSha256 = "sha256-GNZhzOp4orMBgJXIozOsswZXn7QR/ji1NFYwLFiw/3c=";

  buildPhase = ''
    runHook preBuild
    CGO_ENABLED=0 go build -o rfidserver .
    runHook postBuild
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv rfidserver $out/bin
    cp localhost.crt localhost.key $out/bin
  '';

  meta = with lib; {
    homepage = "https://github.com/bezahl-online/RFID";
    description = "RFID server code";
    license = licenses.mit;
    maintainers = with maintainers; [ ralpheichelberger ];
  };
}

