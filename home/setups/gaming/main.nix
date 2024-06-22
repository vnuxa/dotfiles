{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    # launchers
    steam
    gamemode

    winetricks
    protontricks

    # for minecraft
    prismlauncher
    openjdk8-bootstrap
    moonlight-qt

    # modding
    r2modman
  ];
}
