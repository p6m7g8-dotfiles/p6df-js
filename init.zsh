######################################################################
#<
#
# Function: p6df::modules::js::deps()
#
#  Depends:	 p6_git
#>
######################################################################
p6df::modules::js::deps() {
  ModuleDeps=(
    p6m7g8-dotfiles/p6common
    nodenv/nodenv
    nodenv/node-build
    ohmyzsh/ohmyzsh:plugins/npm
    ohmyzsh/ohmyzsh:plugins/yarn
  )
}

######################################################################
#<
#
# Function: p6df::modules::js::vscodes()
#
#>
######################################################################
p6df::modules::js::vscodes() {

  # webasm/ts/js/deno/node/html/css
  code --install-extension dbaeumer.vscode-eslint
  code --install-extension GregorBiswanger.json2ts

  code --install-extension dkundel.vscode-npm-source
  code --install-extension meganrogge.template-string-converter
  code --install-extension BriteSnow.vscode-toggle-quotes
  code --install-extension steoates.autoimport
  code --install-extension wix.glean
  code --install-extension wix.vscode-import-cost
  code --install-extension dsznajder.es7-react-js-snippets

  code --install-extension bradgashler.htmltagwrap
  code --install-extension formulahendry.auto-close-tag
  code --install-extension formulahendry.auto-rename-tag

  code --install-extension ecmel.vscode-html-css
  code --install-extension bourhaouta.tailwindshades
  code --install-extension bradlc.vscode-tailwindcss
  code --install-extension PeterMekhaeil.vscode-tailwindcss-explorer
  code --install-extension sudoaugustin.tailwindcss-transpiler

  #  code --install-extension denoland.vscode-deno
}

######################################################################
#<
#
# Function: p6df::modules::js::home::symlink()
#
#  Depends:	 p6_dir p6_file p6_git
#  Environment:	 P6_DFZ_SRC_DIR P6_DFZ_SRC_P6M7G8_DOTFILES_DIR
#>
######################################################################
p6df::modules::js::home::symlink() {

  p6_dir_mk "$P6_DFZ_SRC_DIR/nodenv/nodenv/plugins"
  p6_file_symlink "$P6_DFZ_SRC_DIR/nodenv/node-build" "$P6_DFZ_SRC_DIR/nodenv/nodenv/plugins/node-build"
  p6_file_symlink "$P6_DFZ_SRC_P6M7G8_DOTFILES_DIR/p6df-js/share/.npm" ".npm"
}

######################################################################
#<
#
# Function: p6df::modules::js::external::brews()
#
#  Depends:	 p6_git
#  Environment:	 DENO_DIR
#>
######################################################################
p6df::modules::js::external::brews() {

  # DENO_DIR defaults to $HOME/.cache/deno
  # deno completions zsh
  brew install deno
}

######################################################################
#<
#
# Function: p6df::modules::js::langs()
#
#  Depends:	 p6_git
#  Environment:	 P6_DFZ_SRC_DIR
#>
######################################################################
p6df::modules::js::langs() {

  p6df::modules::js::langs::nodenv
  p6df::modules::js::langs::bun
}

p6df::modules::js::langs::bun() {

  BUN_INSTALL=$P6_DFZ_SRC_DIR/bun curl https://bun.sh/install | bash
}

p6df::modules::js::langs::nodenv() {
  # update both
  (
    p6_dir_cd "$P6_DFZ_SRC_DIR/nodenv/node-build"
    p6_git_p6_pull
  )
  (
    p6_dir_cd "$P6_DFZ_SRC_DIR/nodenv/nodenv"
    p6_git_p6_pull
  )

  local ver_major
  for ver_major in 14 16 18; do
    # nuke the old one
    local previous=$(nodenv install -l | grep ^$ver_major | tail -2 | head -1)
    nodenv uninstall -f $previous

    # get the shiny one
    local latest=$(nodenv install -l | grep ^$ver_major | tail -1)

    nodenv install -s $latest
    nodenv global $latest
    nodenv rehash

    npm install -g npm
    npm install -g yarn lerna
    nodenv rehash
  done
}

######################################################################
#<
#
# Function: p6df::modules::js::aliases::lerna()
#
#>
######################################################################
p6df::modules::js::aliases::lerna() {

  # runs an npm script via lerna for a the current module
  alias lr='lerna run --stream --scope $(node -p "require(\"./package.json\").name")'

  # runs "npm run build" (build + test) for the current module
  alias lb='lr build'
  alias lt='lr test'

  # runs "npm run watch" for the current module (recommended to run in a separate terminal session)
  alias lw='lr watch'
}

######################################################################
#<
#
# Function: p6df::modules::js::aliases::yarn()
#
#  Depends:	 p6_echo
#>
######################################################################
p6df::modules::js::aliases::yarn() {

  alias yd='yarn deploy'
  alias yD='yarn destroy'
}

######################################################################
#<
#
# Function: p6df::modules::js::aliases::deno()
#
#  Depends:	 p6_echo
#>
######################################################################
p6df::modules::js::aliases::deno() {

  alias db='deno bundle'
  alias dc='deno compile'
  alias dca='deno cache'
  alias dfmt='deno fmt'
  alias dh='deno help'
  alias dli='deno lint'
  alias drn='deno run'
  alias drw='deno run --watch'
  alias dts='deno test'
  alias dup='deno upgrade'
}
######################################################################
#<
#
# Function: p6df::modules::js::init()
#
#  Environment:	 P6_DFZ_SRC_DIR
#>
######################################################################
p6df::modules::js::init() {

  p6df::modules::js::aliases::lerna
  p6df::modules::js::aliases::yarn
  p6df::modules::js::aliases::deno
  p6df::modules::js::nodenv::init "$P6_DFZ_SRC_DIR"
  p6df::modules::js::bun::init "$P6_DFZ_SRC_DIR"

  p6df::modules::js::prompt::init
}

p6df::modules::js::bun::init() {
  local dir="$1"

  # bun completions
  p6_file_load "$dir/bun/_bun"

  # Bun
  p6_env_export BUN_INSTALL "$dir/bun"
  p6_path_if "$BUN_INSTALL/bin"
}

######################################################################
#<
#
# Function: p6df::modules::js::prompt::init()
#
#  Depends:	 p6_echo
#>
######################################################################
p6df::modules::js::prompt::init() {

  p6df::core::prompt::line::add "p6_lang_prompt_info"
  p6df::core::prompt::line::add "p6_lang_envs_prompt_info"
  p6df::core::prompt::lang::line::add node
}

######################################################################
#<
#
# Function: p6df::modules::js::nodenv::init(dir)
#
#  Args:
#	dir -
#
#  Environment:	 DISABLE_ENVS HAS_NODENV NODENV_ROOT
#>
######################################################################
p6df::modules::js::nodenv::init() {
  local dir="$1"

  [ -n "$DISABLE_ENVS" ] && return

  NODENV_ROOT=$dir/nodenv/nodenv

  if [ -x $NODENV_ROOT/bin/nodenv ]; then
    export NODENV_ROOT
    export HAS_NODENV=1

    p6_path_if $NODENV_ROOT/bin
    eval "$(nodenv init - zsh)"
  fi
}

######################################################################
#<
#
# Function: p6df::modules::js::prompt_info()
#
#  Depends:	 p6_echo p6_node
#>
######################################################################
p6df::modules::js::prompt_info() {

  p6df::core::prompt::lang::line::add node
}

######################################################################
#<
#
# Function: p6_node_env_prompt_info()
#
#  Depends:	 p6_echo
#  Environment:	 NODENV_ROOT
#>
######################################################################
p6_node_env_prompt_info() {
  p6_echo "nodenv_root=$NODENV_ROOT"
}

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
