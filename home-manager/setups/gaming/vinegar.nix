{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeBinaryWrapper,
  pkg-config,
  libGL,
  libxkbcommon,
  xorg,
  wayland,
  vulkan-headers,
  wineWowPackages,
  fetchpatch,
}: let
  # wine-staging doesn't support overrideAttrs for now
  wine = wineWowPackages.stagingFull.overrideDerivation (oldAttrs: {
    patches =
      (oldAttrs.patches or [])
      ++ [
        # upstream issue: https://bugs.winehq.org/show_bug.cgi?id=55604
        # Here are the currently applied patches for Roblox to run under WINE:
        (fetchpatch {
          name = "vinegar-wine-segrevert.patch";
          url = "https://cdn.discordapp.com/attachments/1099853933712773193/1198842257588109333/segregrevert.mypatch?ex=65c05fdb&is=65adeadb&hm=25e51210f43d32fa52940af6f2cd5559d9e3857d6f5921cb98b61b3d1b2ea103&";
          hash = "sha256-+3Nld81nG3GufI4jAF6yrWfkJmsSCOku39rx0Hov29c=";
        })
      ];
  });
in
  buildGoModule rec {
    pname = "vinegar";
    version = "1.5.9";

    src = fetchFromGitHub {
      owner = "vinegarhq";
      repo = "vinegar";
      rev = "v${version}";
      hash = "sha256-cLzQnNmQYyAIdTGygk/CNU/mxGgcgoFTg5G/0DNwpz4=";
    };

    vendorHash = "sha256-DZI4APnrldnwOmLZ9ucFBGQDxzPXTIi44eLu74WrSBI=";

    nativeBuildInputs = [pkg-config makeBinaryWrapper];
    buildInputs = [libGL libxkbcommon xorg.libX11 xorg.libXcursor xorg.libXfixes wayland vulkan-headers wine];

    buildPhase = ''
      runHook preBuild
      make PREFIX=$out
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      make PREFIX=$out install
      runHook postInstall
    '';

    postInstall = ''
      wrapProgram $out/bin/vinegar \
        --prefix PATH : ${lib.makeBinPath [wine]}
    '';

    meta = with lib; {
      description = "An open-source, minimal, configurable, fast bootstrapper for running Roblox on Linux";
      homepage = "https://github.com/vinegarhq/vinegar";
      changelog = "https://github.com/vinegarhq/vinegar/releases/tag/v${version}";
      mainProgram = "vinegar";
      license = licenses.gpl3Only;
      platforms = ["x86_64-linux"];
      maintainers = with maintainers; [nyanbinary];
    };
  }