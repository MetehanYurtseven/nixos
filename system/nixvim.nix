{ pkgs, ... }:

let
  # WORKAROUND: Skip build-time require checks for nvim-treesitter-textobjects
  #
  # The nixpkgs neovim-require-check runs during build in an isolated environment
  # where nvim-treesitter is not yet available, causing the check to fail.
  # This is a known issue with treesitter plugins that have runtime dependencies.
  #
  # The plugin works perfectly at runtime when nvim-treesitter is loaded.
  #
  # TODO: Remove this workaround once nixpkgs fixes the dependency resolution
  # Related issues:
  # - https://github.com/NixOS/nixpkgs/issues/282927
  # - https://github.com/NixOS/nixpkgs/issues/318925
  # - https://nixos.org/manual/nixpkgs/unstable/#testing-neovim-plugins-neovim-require-check
  nvim-treesitter-textobjects-fixed =
    pkgs.vimPlugins.nvim-treesitter-textobjects.overrideAttrs
      (old: {
        doCheck = false;
      });
in
{
  environment.systemPackages = with pkgs; [
    nvimpager
  ];

  programs.nixvim = {
    enable = true;

    globals.mapleader = " ";

    opts = {
      relativenumber = true;
      number = true;
      tabstop = 2;
      shiftwidth = 2;
      expandtab = true;
      clipboard = "unnamedplus";
      ignorecase = true;
      smartcase = true;
      signcolumn = "yes";
      termguicolors = true;
      updatetime = 250;
      cursorline = true;
      mouse = "a";
      splitright = true;
      splitbelow = true;
      wrap = false;
      inccommand = "split";
    };

    colorschemes.rose-pine.enable = true;

    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        name = "kitty-scrollback.nvim";
        src = pkgs.kitty-scrollback-nvim;
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

      treesitter = {
        # Syntax Highlighting
        enable = true;

        nixvimInjections = true;

        settings = {
          highlight.enable = true;
          indent.enable = true;
          incremental_selection.enable = true;
        };
      };

      treesitter-context.enable = true;

      treesitter-textobjects = {
        enable = true;
        package = nvim-treesitter-textobjects-fixed;

        settings = {
          select = {
            enable = true;
            keymaps = {
              "af" = "@function.outer";
              "if" = "@function.inner";
              "ac" = "@class.outer";
              "ic" = "@class.inner";
            };
          };
        };
      };

      blink-cmp = {
        # Auto Completion
        enable = true;
        settings = {
          keymap = {
            "<C-j>" = [
              "select_next"
              "fallback"
            ];
            "<C-k>" = [
              "select_prev"
              "fallback"
            ];
            "<C-l>" = [
              "select_and_accept"
              "fallback"
            ];
          };
        };
      };

      web-devicons.enable = true;

      telescope = {
        # Fuzzy Finder
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
