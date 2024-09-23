# This overlay, when applied to nixpkgs, adds the final neovim derivation to nixpkgs.
{
  inputs,
  neovim-unwrapped,
}: final: prev: let
  # Build package
  package = import ./package.nix {
    pkgs = final;
    lib = final;
    inherit inputs;
    inherit neovim-unwrapped;
  };
in {
  # Derivation returned by overlay
  nvim-pkg = package.nvim-pkg;
  # Symlinked in devShell shellHook
  nvim-luarc-json = package.nvim-luarc-json;
}
#
#   # Make sure we use the pinned nixpkgs instance for wrapNeovimUnstable,
#   # otherwise it could have an incompatible signature when applying this overlay.
#   pkgs-wrapNeovim = inputs.nixpkgs.legacyPackages.${pkgs.system};
#
#
#   # A plugin can either be a package or an attrset, such as
#   # { plugin = <plugin>; # the package, e.g. pkgs.vimPlugins.nvim-cmp
#   #   config = <config>; # String; a config that will be loaded with the plugin
#   #   # Boolean; Whether to automatically load the plugin as a 'start' plugin,
#   #   # or as an 'opt' plugin, that can be loaded with `:packadd!`
#   #   optional = <true|false>; # Default: false
#   #   ...
#   # }
#
#
#   # You can add as many derivations as you like.
#   # Use `ignoreConfigRegexes` to filter out config
#   # files you would not like to include.
#   #
#   # For example:
#   #
#   # nvim-pkg-no-telescope = mkNeovim {
#   #   plugins = [];
#   #   ignoreConfigRegexes = [
#   #     "^plugin/telescope.lua"
#   #     "^ftplugin/.*.lua"
#   #   ];
#   #   inherit extraPackages;
#   # };
# }

