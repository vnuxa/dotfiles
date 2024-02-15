inputs: final: prev:
let
  # old =
    # import inputs.nixpkgs-old ({ localSystem = { inherit (final) system; }; });
  inherit (final) system lib;
in rec {

  config-lib = import ./config-lib.nix lib;

}
