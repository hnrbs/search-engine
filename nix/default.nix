{ pkgs, nix-filter }:

with pkgs.ocamlPackages;
buildDunePackage rec {
  pname = "search-engine";
  version = "0.0.0-dev";

  src = with nix-filter.lib;
    filter {
      root = ./..;
      include = [ "dune-project" "src" ];
      exclude = [ ];
    };

  propagatedBuildInputs = [
    utop
    lambdasoup
    ppx_deriving
    piaf
    eio_main
    caqti
    caqti-eio
    caqti-driver-postgresql
    ppx_rapper
    ppx_rapper_eio
    routes
    ppx_deriving_yojson
  ] ++ checkInputs;

  checkInputs = [ alcotest ];
}
