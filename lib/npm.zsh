# shellcheck shell=bash
######################################################################
#<
#
# Function: p6_js_npm_global_install(mod)
#
#  Args:
#	mod -
#
#>
######################################################################
p6_js_npm_global_install() {
  local mod="$1"

  npm uninstall -g "$mod"
  npm install -g "$mod"
  npm list -g --depth 0
  nodenv rehash
}
