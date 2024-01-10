{
    enable = true;

    # Load other extensions
    extraLua.post = ''
        require("telescope").load_extension "file_browser"
    '';
}
