let
  lock = import ./lon.nix;

  pkgs = import lock.nixpkgs { };
in
pkgs.mkShellNoCC {
  # `with pkgs;` prepends `pkgs.` to every element in the list
  packages = with pkgs; [
    graphviz
    lon
    nixfmt-rfc-style
    opentofu
    trivy
  ];

  # Non-default shells used by GitHub Actions, selected with `nix-shell -A {{ key }}`
  passthru = {
    # nix-shell used by the `lon` workflow
    lon = pkgs.mkShellNoCC {
      packages = [ pkgs.lon ];
    };

    # nix-shell used by the `ci` and `opentofu` workflows
    opentofu = pkgs.mkShellNoCC {
      packages = [ pkgs.opentofu ];
    };

    # nix-shell used by the `registry` workflow
    registry = pkgs.mkShellNoCC {
      packages = [ (pkgs.callPackage lock.Anamnesis { }).client ];
    };

    # nix-shell used by the `ci` workflow
    trivy = pkgs.mkShellNoCC {
      packages = [ pkgs.trivy ];
    };
  };
}
