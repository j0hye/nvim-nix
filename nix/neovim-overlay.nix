# This overlay, when applied to nixpkgs, adds the final neovim derivation to nixpkgs.
{
  inputs,
  neovim-unwrapped,
}: final: prev: let
  # Build package
  package = import ./package.nix {
    pkgs = final;
    lib = final;
    config = final;
    inherit inputs;
    inherit neovim-unwrapped;
  };
in {
  # Derivation returned by overlay
  nvim-pkg = package.nvim-pkg;
  # Symlinked in devShell shellHook
  nvim-luarc-json = package.nvim-luarc-json;
}
