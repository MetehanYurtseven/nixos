{ pkgs, ... }: 

let
  kitty-scrollback-nvim-src = pkgs.callPackage ../packages/kitty-scrollback-nvim.nix { };
in
{
  environment.systemPackages = with pkgs; [
    nvimpager
  ];

  programs.nixvim = {
    enable = true;
    opts = {
      relativenumber = true;
      tabstop = 2;
      shiftwidth = 2;
      expandtab = true;
    };

    colorschemes.rose-pine.enable = true;

    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        name = "kitty-scrollback.nvim";
        src = kitty-scrollback-nvim-src;
      })
    ];

    plugins = {
      lualine.enable = true;

      lsp = {
        enable = true;

        keymaps = {
          diagnostic = {
            "<leader>e" = "open_float";
            "[d" = "goto_prev";
            "]d" = "goto_next";
            "<leader>q" = "setloclist";
          };

          lspBuf = {
            "gd" = "definition";
            "gD" = "declaration";
            "gr" = "references";
            "gi" = "implementation";
            "K" = "hover";
            "<leader>rn" = "rename";
            "<leader>ca" = "code_action";
          };
        };

        servers = {
          nixd.enable = true;
          pyright.enable = true;
          bashls.enable = true;
          ccls.enable = true;
          cmake.enable = true;
          docker_language_server.enable = true;
          eslint.enable = true;
          html.enable = true;
          jsonls.enable = true;
          lua_ls.enable = true;
          marksman.enable = true;
          yamlls.enable = true;
        };
      };

      treesitter = { # Syntax Highlighting
        enable = true;

        nixvimInjections = true;

        settings = {
          highlight.enable = true;
          indent.enable = true;
          incremental_selection.enable = true;
        };
      };

      treesitter-context.enable = true;
      treesitter-refactor.enable = true;
      treesitter-textobjects.enable = true;

      blink-cmp = { # Auto Completion
        enable = true;
        settings = {
          keymap = {
            "<C-j>" = [ "select_next" "fallback" ];
            "<C-k>" = [ "select_prev" "fallback" ];
            "<C-l>" = [ "select_and_accept" "fallback" ];
          };
        };
      };

      telescope = { # Fuzzy Finder
        enable = true;
        keymaps = {
          "<C-t>" = {
            action = "find_files";
          };
        };
      };
    };
  };
}

