{ pkgs, config, lib, inputs, ... }:
{
  config = {
      home.file."hamachi-connect.sh".source =
          let
          script = pkgs.writeShellScriptBin "hamachi-connect.sh" ''
            ls ${pkgs.logmein-hamachi}/bin/
            ${pkgs.logmein-hamachi}/bin/hamachid start
          '';
      in 
          "${script}/bin/hamachi-connect.sh";

  };
}
