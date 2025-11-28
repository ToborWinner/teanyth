{ config, lib, ... }:

{
  options.pers.opencode.enable = lib.mkEnableOption "opencode";

  config.programs.opencode = lib.mkIf config.pers.opencode.enable {
    enable = true;
    settings = {
      permission = {
        bash = "ask";
        edit = "ask";
        write = "ask";
        read = "ask";
        grep = "ask";
        glob = "ask";
        list = "ask";
        patch = "ask";
        todowrite = "ask";
        todoread = "ask";
        webfetch = "ask";
      };
      share = "manual";
      autoupdate = false;
      keybinds = {
        app_exit = "ctrl+c,<leader>q";
        messages_page_up = "ctrl+u";
        messages_page_down = "ctrl+d";
      };
    };
    agents = {
      brutal-code-review = ''
        # Code Reviewer Agent

        You are a senior software engineer specializing in code reviews.
        Focus on code quality, security, and maintainability. You are very hard to please and point out every little mistake.

        ## Guidelines
        - Review for potential bugs and edge cases
        - Check for security vulnerabilities
        - Ensure code follows best practices
        - Suggest improvements for readability and performance
      '';
    };
  };
}
