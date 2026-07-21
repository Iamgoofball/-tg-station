{ lib
, stdenvNoCC
, fetchurl
, makeWrapper
, icoutils      # wrestool/icotool: extract the BYOND icon from the installer PE
, wineWowPackages
, winePackage ? wineWowPackages.stable  # overridable; see flake.nix (wine 10 vs 11)
, winetricks
, bubblewrap
, cabextract
, p7zip
, samba         # provides ntlm_auth, occasionally wanted by wine
, gnused
, coreutils
, findutils
, util-linux
, procps        # pkill, used to terminate MicrosoftEdgeUpdate.exe
, bash
, xvfb
}:

let
  version = "516.1680";
  # Multiarch wow (32-bit + 64-bit). flake.nix pins wineWowPackages.staging (latest
  # dev + staging patchset); the wineWowPackages.stable default here is just a
  # sensible fallback. `winePackage` is overridable so any wine can be pinned.
  wine = winePackage;

  # Fixed-output sources. Hashes obtained via `nix store prefetch-file`.
  byondInstaller = fetchurl {
    # Lutris pulls this over plain http; we use https + a pinned hash.
    url = "https://www.byond.com/download/build/516/516.1680_byond.exe";
    hash = "sha256-4EE2IMGLqQ4TV6gmcSs3+Tl508pNuTs/d+UbcMfbYkE=";
  };

  # The WebView2 evergreen bootstrapper. NOTE: this fwlink redirects to
  # whatever Microsoft currently ships, so the hash can drift over time.
  # Refresh with:
  #   nix store prefetch-file --name MicrosoftEdgeWebView2RuntimeInstallerX64.exe \
  #     "https://go.microsoft.com/fwlink/?linkid=2124701"
  webview2Installer = fetchurl {
    url = "https://go.microsoft.com/fwlink/?linkid=2124701";
    name = "MicrosoftEdgeWebView2RuntimeInstallerX64.exe";
    hash = "sha256-rxBn2cx/EHypbd2NUhJyS9rjvZ60bmGdLKXB8+MEFhI=";
  };

  runtimePath = lib.makeBinPath

  # Define the screenshot harness
  screenshotHarness = stdenvNoCC.mkDerivation {
    name = "screenshot-harness";
    src = ./.;

    buildInputs = [ wine xvfb ];

    installPhase = ''
      mkdir -p $out/bin
      cp tests/screenshot_harness.sh $out/bin/
      chmod +x $out/bin/screenshot_harness.sh
    '';
  };
in
{
  description = "Nix flake for /tg/station with screenshot harness";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.wine
            pkgs.xvfb
            pkgs.cabextract
            pkgs.p7zip
            pkgs.samba
            pkgs.gnused
            pkgs.coreutils
            pkgs.findutils
            pkgs.util-linux
            pkgs.procps
            pkgs.bash
          ];

          shellHook = ''
            echo "Development environment ready. Use 'screenshot_harness.sh' to take screenshots."
          '';
        };

        packages.default = screenshotHarness;
      });
}