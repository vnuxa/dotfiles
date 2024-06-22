{
  FormatAutogroup = {
    autocmds = [
      {
        event = "BufWritePost";
        pattern = "*";
        command = "FormatWrite";
      }
    ];
  };
}
