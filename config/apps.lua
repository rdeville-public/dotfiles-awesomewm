return {
  terminal   = "st" or "terminator" or "xterm",
  editor     = os.getenv("EDITOR") or "vim" or "vi" or "nano",
  gui_editor = os.getenv("GUI_EDITOR") or "gvim",
  browser    = os.getenv("BROWSER") or "firefox" or "chromium-browser",
  explorer   = "pcmanfm" or "thunar",
}
