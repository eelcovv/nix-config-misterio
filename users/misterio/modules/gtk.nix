{ config, pkgs, lib, ... }:

let
  colors = config.colorscheme.colors;
  materia-theme = pkgs.fetchFromGitHub {
    owner = "nana-4";
    repo = "materia-theme";
    rev = "76cac96ca7fe45dc9e5b9822b0fbb5f4cad47984";
    sha256 = "sha256-0eCAfm/MWXv6BbCl2vbVbvgv8DiUH09TAUhoKq7Ow0k=";
    fetchSubmodules = true;
  };
  materia_colors = pkgs.writeTextFile {
    name = "gtk-generated-colors";
    text = ''
      BTN_BG=${colors.base02}
      BTN_FG=${colors.base06}
      FG=${colors.base05}
      BG=${colors.base00}
      HDR_BTN_BG=${colors.base01}
      HDR_BTN_FG=${colors.base05}
      ACCENT_BG=${colors.base0B}
      ACCENT_FG=${colors.base00}
      HDR_FG=${colors.base05}
      HDR_BG=${colors.base02}
      MATERIA_SURFACE=${colors.base02}
      MATERIA_VIEW=${colors.base01}
      MENU_BG=${colors.base02}
      MENU_FG=${colors.base06}
      SEL_BG=${colors.base0D}
      SEL_FG=${colors.base0E}
      TXT_BG=${colors.base02}
      TXT_FG=${colors.base06}
      WM_BORDER_FOCUS=${colors.base05}
      WM_BORDER_UNFOCUS=${colors.base03}
      UNITY_DEFAULT_LAUNCHER_STYLE=False
      NAME=${config.colorscheme.slug}
      MATERIA_STYLE_COMPACT=True
    '';
  };
in {

  nixpkgs.overlays = [
    (self: super: {
      rendersvg = self.runCommandNoCC "rendersvg" { } ''
        mkdir -p $out/bin
        ln -s ${self.resvg}/bin/resvg $out/bin/rendersvg
      '';
      generated-gtk-theme = self.stdenv.mkDerivation rec {
        name = "generated-gtk-theme";
        src = materia-theme;
        buildInputs = with self; [ sassc bc which rendersvg meson ninja nodePackages.sass gtk4.dev optipng ];
        MATERIA_COLORS = materia_colors;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          HOME=/build
          chmod 777 -R .
          patchShebangs .
          mkdir -p $out/share/themes
          mkdir bin
          sed -e 's/handle-horz-.*//' -e 's/handle-vert-.*//' -i ./src/gtk-2.0/assets.txt
          echo "Changing colours:"
          ./change_color.sh -o ${config.colorscheme.slug} "$MATERIA_COLORS" -i False -t "$out/share/themes"
          chmod 555 -R .
        '';
      };
    })
  ];

  # GTK settings
  gtk = {
    enable = true;

    font = {
      name = "Fira Sans";
      size = 12;
    };

    iconTheme = {
        name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };

    theme = {
      name = "${config.colorscheme.slug}";
      package = pkgs.generated-gtk-theme;
    };

  };

  home.sessionVariables.GTK_THEME = "${config.colorscheme.slug}";
}
