post_install() {
  xdg-icon-resource forceupdate --theme hicolor 2> /dev/null
  echo "when you use a non-reparenting window manager"
  echo "set _JAVA_AWT_WM_NONREPARENTING=1 in"
  echo "/etc/profile.d/jre.sh"
}

post_upgrade() {
  xdg-icon-resource forceupdate --theme hicolor 2> /dev/null
}


post_remove() {
  xdg-icon-resource forceupdate --theme hicolor 2> /dev/null
}
