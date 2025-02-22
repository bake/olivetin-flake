{
  description = "A module for OliveTin";

  inputs.nixpkgs.url = "nixpkgs/nixos-24.11";

  outputs = { self, nixpkgs }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
    in
    {
      packages = forAllSystems (system:
        let pkgs = nixpkgsFor.${system};
        in rec {
          olivetin = pkgs.callPackage ./pkg.nix { };
          webui = pkgs.callPackage ./webui.nix { };
          default = olivetin;
        });

      nixosModules.default = import ./module.nix;
    };
}
