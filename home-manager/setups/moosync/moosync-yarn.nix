{
    lib,
    fetchFromGitHub,
    mkYarnPackage,
    stdenv,
    pkgs,
    makeWrapper,
    fetchYarnDeps,
}:

mkYarnPackage rec {
    pname = "Moosync";
    version = "10.3.2"; # update whenever

    src = fetchFromGitHub {
        owner = "Moosync";
        repo = "Moosync";
        rev = "v${version}"; 
        sha256 = "sha256-0saO8ueQFNFpwBgXDfT7xMNDOgNNVgLklWXRVtxXjME=";
    };

    # reminder that this needs to be updated constantly
    packageJSON = ./moosync-package.json;
    
    # The dependency expression can be regenerated using nixos.yarn2nix with the following command:
    # yarn2nix --lockfile=(lock file here) > (filename).nix
    yarnNix = ./moosync-yarndeps.nix;
    #FIXME: the moosync/node-rodio-backend needs to be cloned!!
# "rodio-audio-backend": "git+https://github.com/Moosync/node-rodio-backend",
# is missing from moosync-package.json on line 106

    # offlineCache = fetchYarnDeps {
    #     yarnLock = src + "./yarn.lock";
    #     hash = "....";
    # };
# offline cache might be fine??

    buildInputs = with pkgs; [
        yarn
    ];
    # dont general tarball
    # note: `doDist = false;` does not work.
    # distPhase = ''
    #     true
    # '';

    # nativeBuildInputs = [ makeWrapper ];
    #
    buildPhase = ''
        runHook preBuild
        # echo "buildphaseeee :D"
        export HOME=$(mktemp -d)
        yarn --offline build
        runHook postBuild
    '';
    configurePhase = ''
        ln -s $node_modules node_modules
    '';

    #dont build another binary
    distPhase = "true";
    #
    # installPhase = ''
    #     runHook preInstall
    #     echo "yayyyyyyyyyyy install phase"
    #
    #     runHook postInstall
    # '';

    # installPhase = ''
    #     mkdir -p $out/bin
    #     cd $out
    #     echo "preinstall"
    #     yarn --offline install
    #     echo "after install!!! yay"
    #
    #     yarn postinstall
    #     yarn electron:serve
    # '';

}

