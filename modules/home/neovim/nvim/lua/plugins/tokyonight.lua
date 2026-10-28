-- Let kitty's translucent background show through, sidebars and floats included
return {
  {
    "folke/tokyonight.nvim",
    opts = {
      transparent = true,
      styles = { sidebars = "transparent", floats = "transparent" },
    },
  },
}
