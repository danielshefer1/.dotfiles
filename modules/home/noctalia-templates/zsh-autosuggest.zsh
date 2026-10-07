# zsh-autosuggestions color. The plugin's default (fg=8, bright black) is close to or equal to the
# background in many palettes; a mid-lightness text color stays readable in dark and light modes.
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg={{ colors.on_surface.default.hex | set_lightness 50 }}"
