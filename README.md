# OliveTin Flake

A simple flake for [OliveTin](https://github.com/OliveTin/OliveTin) with a NixOS module.

## Installation

Run Olivetin:

```bash
nix run github:bake/olivetin-flake
```

To use the module first add the flake to your `flake.nix`:

```nix
{
  inputs.olivetin.url = "github:bake/olivetin-flake";
}
```

Then add the module to your configuration:

```nix
{
  imports = [
    inputs.olivetin.nixosModules.default
  ];
}
```

And finally enable the module and configure actions:

```nix
{
  services.olivetin = {
    enable = true;
    settings.actions = [
      { title = "NixOS Module"; shell = "echo 'Hello from NixOS!'"; }
    ];
  };
}
```
