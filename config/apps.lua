terminal        = "st" or "terminator" or "xterm"

return {
  terminal          = terminal,
  editor            = os.getenv("EDITOR")            or "vim"                   or "vi"                or "nano",
  gui_editor        = os.getenv("GUI_EDITOR")        or "gvim",
  browser           = os.getenv("BROWSER")           or "firefox"               or "chromium-browser",
  explorer          = "pcmanfm"                      or "thunar",
  network_manager   = terminal .. " -e nmtui"        or "nm-connection-editor",
  bluetooth_manager = terminal .. " -e bluetoothctl" or "blueman-manager",
}