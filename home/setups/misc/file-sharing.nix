{ pkgs, ... }:
{
    # makes it so that i can upload specified file types within nemo file manager

    # this will use curl and sxcu.net
    # allowed file types: [png, gif, jpeg, ico, bmp, tiff, webm, webp]
    config = {
        home.file.".local/share/nemo/scripts/upload_file.sh".source =
            let
            script = pkgs.writeShellScriptBin "upload_file.sh" ''
                cd $NEMO_SCRIPT_SELECTED_FILE_PATHS 

                upload_domain="https://vau.click-if-you-da.re/api/files/create"

                curl -s -F file=@"$1" -F 'noembed=true' -F 'og_propreties="{\"discord_hide_url\":true}"' $upload_domain | jq '.url' | tr -d '"' | wl-copy
            '';

        in 
            "${script}/bin/upload_file.sh";

    };
}

