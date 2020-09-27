######################################################################
#<
#
# Function: p6df::modules::node::version()
#
#>
######################################################################
p6df::modules::node::version() { echo "0.0.1" }
######################################################################
#<
#
# Function: p6df::modules::node::deps()
#
#>
######################################################################
p6df::modules::node::deps()    { ModuleDeps=(
      nodenv/nodenv 
      nodenv/node-build
      ohmyzsh/ohmyzsh:plugins/npm
      ohmyzsh/ohmyzsh:plugins/yarn
    )  
}

#p6df::modules::node::external::brew() { }

######################################################################
#<
#
# Function: p6df::modules::node::home::symlink()
#
#>
######################################################################
p6df::modules::node::home::symlink() { 

  mkdir -p $P6_DFZ_SRC_DIR/nodenv/nodenv/plugins
  ln -fs $P6_DFZ_SRC_DIR/nodenv/node-build $P6_DFZ_SRC_DIR/nodenv/nodenv/plugins/node-build
}

######################################################################
#<
#
# Function: p6df::modules::node::langs()
#
#>
######################################################################
p6df::modules::node::langs() {

  # update both
  (cd $P6_DFZ_SRC_DIR/nodenv/node-build ; git pull)
  (cd $P6_DFZ_SRC_DIR/nodenv/nodenv ; git pull)

  # nuke the old one
  local previous=$(nodenv install -l | grep ^1 | tail -2 | head -1)
  nodenv uninstall -f $previous

  # get the shiny one
  local latest=$(nodenv install -l | grep ^1 | tail -1)
  nodenv install -s $latest
  nodenv global $latest
  nodenv rehash
}

######################################################################
#<
#
# Function: p6df::modules::node::init()
#
#>
######################################################################
p6df::modules::node::init() {

  p6df::modules::node::nodenv::init "$P6_DFZ_SRC_DIR"
}

######################################################################
#<
#
# Function: p6df::modules::node::nodenv::init(dir)
#
#  Args:
#	dir - 
#
#>
######################################################################
p6df::modules::node::nodenv::init() {
  local dir="$1"

  [ -n "$DISABLE_ENVS" ] && return

  NODENV_ROOT=$dir/nodenv/nodenv

  if [ -x $NODENV_ROOT/bin/nodenv ]; then
    export NODENV_ROOT
    export HAS_NODENV=1

    p6df::util::path_if $NODENV_ROOT/bin
    eval "$(nodenv init - zsh)"
  fi
}

######################################################################
#<
#
# Function: p6df::prompt::node::line()
#
#>
######################################################################
p6df::prompt::node::line() {

  p6_node_prompt_info
}

######################################################################
#<
#
# Function: p6_node_prompt_info()
#
#>
######################################################################
p6_node_prompt_info() {

  p6_lang_version "node"
}
