{
  pkgs,
  lib,
  inputs,
  neovim-unwrapped,
  config,
}:
with lib; let
  # Use this to create a plugin from a flake input
  mkNvimPlugin = src: pname:
    pkgs.vimUtils.buildVimPlugin {
      inherit pname src;
      version = src.lastModifiedDate;
    };
  # This is the helper function that builds the Neovim derivation.
  mkNeovim = pkgs.callPackage ./mkNeovim.nix {};

  # vimPlugins
  all-plugins = with pkgs.vimPlugins; [
    # Completion
    nvim-cmp
    cmp-nvim-lsp
    cmp-path
    cmp_luasnip

    # Snippets
    luasnip

    # Formatters and LSP
    conform-nvim
    nvim-lspconfig
    fidget-nvim
    lazydev-nvim
    lsp_signature-nvim
    outline-nvim

    # Treesitter
    nvim-treesitter.withAllGrammars
    nvim-treesitter-textobjects
    nvim-ts-context-commentstring
    nvim-treesitter-context

    # Git
    neogit
    gitsigns-nvim

    # Telescope
    telescope-nvim
    telescope-fzf-native-nvim
    telescope-ui-select-nvim

    # UI
    oil-nvim
    lualine-nvim
    nvim-navic
    which-key-nvim
    dressing-nvim
    nvim-notify
    noice-nvim
    indent-blankline-nvim

    # Misc
    trouble-nvim
    flash-nvim
    toggleterm-nvim
    nvim-surround
    nvim-spider
    nvim-unception
    todo-comments-nvim

    # Deps
    nvim-web-devicons
    sqlite-lua
    plenary-nvim
    nvim-nio
    nui-nvim

    # Mini
    mini-nvim

    # Colorscheme
    gruvbox-nvim
  ];
  extraPackages = with pkgs; [
    # language servers, etc.
  ];
  extraLuaPackages = ps:
    with ps; [
      pathlib-nvim
      luautf8 # nvim-spider dep
    ];
in {
  nvim-pkg = mkNeovim {
    inherit neovim-unwrapped;
    plugins = all-plugins;
    inherit extraPackages;
    inherit extraLuaPackages;
  };
  nvim-luarc-json = mk-luarc-json {
    nvim = pkgs.neovim-nightly;
    plugins = all-plugins;
    neodev-types = "nightly";
  };
}
