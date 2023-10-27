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
  pname = "PT API Server";
  repo = "ptapi";
  rev = "v${version}";
  sha256 = "1ikyp1rxrl8lyfbll501f13yir1axighnr8x3ji3qzwin6i3w497";
  vendorHash = null;
in
buildGoModule {
  inherit version repo pname;

  src = fetchFromGitHub {
    owner = "bezahl-online";
    repo = repo;
    rev = "cba38aa5dda1546e7e0d984905cb9ba17b3622da";
    sha256 = "sha256-pvaixSzU+Z7lhjilDsuHDWD5tXW0qhb5QNQ3oq6/lcg=";
  };
  # src = ../${repo}/.;
 
  vendorHash = null;
  buildPhase = ''
    runHook preBuild
    CGO_ENABLED=0 go build -o ptapiserver .
    runHook postBuild
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv ptapiserver $out/bin
    cp localhost.crt localhost.key $out/bin
  '';

  meta = with lib; {
    homepage = "https://github.com/bezahl-online/ptapi";
    description = "ptapi server code";
    license = licenses.mit;
    maintainers = with maintainers; [ /* list of maintainers here */ ];
  };
}

