{
    # lib,
    fetchFromGitHub,
    # mkDerivation,
    # stdenv,
    pkgs,
    # makeWrapper,
    # fetchYarnDeps,
}:
pkgs.stdenv.mkDerivation rec {
    pname = "Moosync";
    version = "10.3.2"; # update whenever

    src = fetchFromGitHub {
        owner = "Moosync";
        repo = "Moosync";
        rev = "v${version}"; 
        sha256 = "sha256-0saO8ueQFNFpwBgXDfT7xMNDOgNNVgLklWXRVtxXjME=";
    };

    buildInputs = with pkgs; [
        yarn
    ];

    buildPhase = ''
        runHook preBuild
        echo "buildphaseeee :D"
        export HOME=$(mktemp -d)
        runHook postBuild
    '';

    installPhase = ''
        mkdir -p $out/bin
        yarn --offline install 
        ls > $out
        cd $out
        # yarn install
    '';
}
