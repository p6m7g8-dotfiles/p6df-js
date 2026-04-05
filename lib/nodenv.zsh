# shellcheck shell=bash
######################################################################
#<
#
# Function: p6df::modules::js::nodenv::latest(ver_major)
#
#  Args:
#	ver_major -
#
#>
######################################################################
p6df::modules::js::nodenv::latest() {
  local ver_major="$1"

  nodenv install -l | p6_filter_row_select "^$ver_major" | p6_filter_row_last "1"
}

######################################################################
#<
#
# Function: p6df::modules::js::nodenv::latest::installed(ver_major)
#
#  Args:
#	ver_major -
#
#>
######################################################################
p6df::modules::js::nodenv::latest::installed() {
  local ver_major="$1"

  nodenv install -l | p6_filter_row_select "^$ver_major" | p6_filter_row_from_end "2"
}
