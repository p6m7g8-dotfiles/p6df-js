# shellcheck shell=bash
######################################################################
#<
#
# Function: p6df::modules::js::deps()
#
#>
######################################################################
p6df::modules::js::deps() {
  ModuleDeps=(
    ohmyzsh/ohmyzsh:plugins/npm
    ohmyzsh/ohmyzsh:plugins/yarn
    nodenv/nodenv
    nodenv/node-build
    p6m7g8/p6-zsh-pnpm-plugin
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

  code --install-extension gregorbiswanger.json2ts
  code --install-extension orta.vscode-jest
  code --install-extension wix.vscode-import-cost
  code --install-extension bradgashler.htmltagwrap
  code --install-extension formulahendry.auto-close-tag
  code --install-extension formulahendry.auto-rename-tag
  code --install-extension bradlc.vscode-tailwindcss
  code --install-extension heybourn.headwind
  code --install-extension bourhaouta.tailwindshades

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::js::home::symlink()
#
#  Environment:	 P6_DFZ_SRC_DIR P6_DFZ_SRC_P6M7G8_DOTFILES_DIR
#>
######################################################################
p6df::modules::js::home::symlink() {

  p6_dir_mk "$P6_DFZ_SRC_DIR/nodenv/nodenv/plugins"
  p6_file_symlink "$P6_DFZ_SRC_DIR/nodenv/node-build" "$P6_DFZ_SRC_DIR/nodenv/nodenv/plugins/node-build"
  p6_file_symlink "$P6_DFZ_SRC_P6M7G8_DOTFILES_DIR/p6df-js/share/.npm" ".npm"

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::js::external::brews()
#
#>
######################################################################
p6df::modules::js::external::brews() {

  # DENO_DIR defaults to $HOME/.cache/deno
  p6df::modules::homebrew::cli::brew::install deno

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::js::langs()
#
#>
######################################################################
p6df::modules::js::langs() {

  p6df::modules::js::langs::nodenv
#  p6df::modules::js::langs::bun

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::js::langs::bun()
#
#  Environment:	 P6_DFZ_SRC_DIR
#>
######################################################################
p6df::modules::js::langs::bun() {

  local file=$(p6_transient_create_file "bun.sh")

  p6_network_file_download "https://bun.sh/install" "$file"
  p6_file_lines_remove "162" "232" "$file"
  p6_file_perms_set "a+rx" "$file"
  p6_run_code "BUN_INSTALL=$P6_DFZ_SRC_DIR/bun"6 "$file"
  p6_file_remove "$file"

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::js::langs::nodenv()
#
#  Environment:	 P6_DFZ_SRC_DIR
#>
######################################################################
p6df::modules::js::langs::nodenv() {

  p6_run_dir "$P6_DFZ_SRC_DIR/nodenv/node-build" p6_git_cli_pull_rebase_autostash_ff_only
  p6_run_dir "$P6_DFZ_SRC_DIR/nodenv/nodenv" p6_git_cli_pull_rebase_autostash_ff_only

  local ver_major
  for ver_major in 22 24; do
    # nuke the old one
    local previous=$(p6df::modules::js::nodenv::latest::installed "$ver_major")
    nodenv uninstall -f "$previous"

    # get the shiny one
    local latest=$(p6df::modules::js::nodenv::latest "$ver_major")

    nodenv install -s "$latest"
    nodenv global "$latest"
    nodenv rehash

    npm install -g npm
    p6_js_npm_global_install "yarn"
    corepack enable
    p6_js_npm_global_install "lerna"
    nodenv rehash
  done

  p6_return_void
}

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

######################################################################
#<
#
# Function: p6df::modules::js::aliases::lerna()
#
#>
######################################################################
p6df::modules::js::aliases::lerna() {

  # runs an npm script via lerna for a the current module
#  p6_alias "lr" "lerna run --stream --scope $(node -p 'require(\'./package.json\').name\')"

  # runs "npm run build" (build + test) for the current module
  p6_alias "lb" "lr build"
  p6_alias "lt" "lr test"

  # runs "npm run watch" for the current module (recommended to run in a separate terminal session)
  p6_alias "lw" "lr watch"

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::js::aliases::yarn()
#
#>
######################################################################
p6df::modules::js::aliases::yarn() {

  alias yd='yarn deploy'
  alias yD='yarn destroy'

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::js::aliases::deno()
#
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

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::js::init(_module, dir)
#
#  Args:
#	_module -
#	dir -
#
#  Environment:	 P6_DFZ_SRC_DIR
#>
######################################################################
p6df::modules::js::init() {
  local _module="$1"
  local dir="$2"

  p6df::core::lang::mgr::init "$P6_DFZ_SRC_DIR/nodenv/nodenv" "nod"

  p6df::modules::js::bun::init "$P6_DFZ_SRC_DIR"

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::js::aliases::init()
#
#>
######################################################################
p6df::modules::js::aliases::init() {

  p6df::modules::js::aliases::lerna
  p6df::modules::js::aliases::yarn
  p6df::modules::js::aliases::deno

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::js::bun::init(dir)
#
#  Args:
#	dir -
#
#  Environment:	 BUN_INSTALL
#>
######################################################################
p6df::modules::js::bun::init() {
  local dir="$1"

  # Bun
  p6_env_export BUN_INSTALL "$dir/bun"
  p6_path_if "$BUN_INSTALL/bin"

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::js::completions::init(module, dir)
#
#  Args:
#	module -
#	dir -
#
#>
######################################################################
p6df::modules::js::completions::init() {
  local module="$1"
  local dir="$2"

  # bun completions
  p6_file_load "$dir/bun/_bun"
}

######################################################################
#<
#
# Function: p6df::modules::js::prompt::env()
#
#>
######################################################################
p6df::modules::js::prompt::env() {

#  local str="nodenv_root:\t  $NODENV_ROOT"
  local str=""

  p6_return "$str"
}

######################################################################
#<
#
# Function: str str = p6df::modules::js::prompt::lang()
#
#  Returns:
#	str - str
#
#>
######################################################################
p6df::modules::js::prompt::lang() {

  local str
  str=$(p6df::core::lang::prompt::lang \
    "node" \
    "nodenv version-name 2>/dev/null" \
    "node -v 2>/dev/null | sed -e 's,v,,'")

  p6_return_str "$str"
}

######################################################################
#<
#
# Function: p6df::modules::js::profile::on(profile, user, token)
#
#  Args:
#	profile -
#	user -
#	token -
#
#  Environment:	 NPM_TOKEN NPM_USER P6_DFZ_PROFILE_NPM
#>
######################################################################
p6df::modules::js::profile::on() {
  local profile="$1"
  local user="$2"
  local token="$3"

  p6_env_export "P6_DFZ_PROFILE_NPM" "$profile"
  p6_env_export NPM_TOKEN "$token"
  p6_env_export NPM_USER "$user"

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::js::profile::off()
#
#  Environment:	 NPM_TOKEN NPM_USER P6_DFZ_PROFILE_NPM
#>
######################################################################
p6df::modules::js::profile::off() {

  p6_env_export_un "P6_DFZ_PROFILE_NPM"
  p6_env_export_un NPM_TOKEN
  p6_env_export_un NPM_USER

  p6_return_void
}

######################################################################
#<
#
# Function: str str = p6df::modules::js::prompt::mod()
#
#  Returns:
#	str - str
#
#  Environment:	 NPM_USER P6_DFZ_PROFILE_NPM P6_NL
#>
######################################################################
p6df::modules::js::prompt::mod() {

  local npm
  if ! p6_string_blank "$P6_DFZ_PROFILE_NPM"; then
    npm="npm:\t\t  $P6_DFZ_PROFILE_NPM:"
    if ! p6_string_blank "$NPM_USER"; then
      npm=$(p6_string_append "$npm" "$NPM_USER" " ")
    fi
  fi

  local pm
  if p6_file_exists "package-lock.json"; then
      pm="${pm}npm "
  fi
  if p6_file_exists "yarn.lock"; then
      pm="${pm}yarn "
  fi
  if p6_file_exists "pnpm-lock.yaml"; then
      pm="${pm}pnpm "
  fi
  if p6_file_exists "lerna.json"; then
      pm="${pm}lerna "
  fi

  if ! p6_string_blank "$pm"; then
    pm="js:\t\t  pm:$pm"
  fi

  local str
  if ! p6_string_blank "$npm"; then
    str="$npm"
    if ! p6_string_blank "$pm"; then
      str=$(p6_string_append "$str" "$pm" "$P6_NL")
    fi
  else
    if ! p6_string_blank "$pm"; then
      str="$pm"
    fi
  fi

  p6_return_str "$str"
}

######################################################################
#<
#
# Function: p6df::modules::js::npm::token::gha()
#
#>
######################################################################
p6df::modules::js::npm::token::gha() {

  npm token create \
    --name gha \
    --token-description "p6 github actions ci/cd" \
    --bypass-2fa \
    --expires 90 \
    --packages-and-scopes-permission read-write \
    --scopes @pgollucci

  p6_return_void
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
