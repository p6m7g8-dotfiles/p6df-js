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
# Function: p6df::modules::js::env::init(_module, _dir)
#
#  Args:
#	_module -
#	_dir -
#
#  Environment:	 BUN_INSTALL P6_DFZ_SRC_DIR
#>
######################################################################
p6df::modules::js::env::init() {
  local _module="$1"
  local _dir="$2"

  # Bun
  p6_env_export BUN_INSTALL "$P6_DFZ_SRC_DIR/bun"
  p6_path_if "$BUN_INSTALL/bin"

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::js::completions::init(_module, dir)
#
#  Args:
#	_module -
#	dir -
#
#  Environment:	 HOME
#>
######################################################################
p6df::modules::js::completions::init() {
  local _module="$1"
  local dir="$2"

  # bun completions
  p6_file_load "$HOME/.bun/_bun"
}


######################################################################
#<
#
# Function: p6df::modules::js::aliases::init(_module, _dir)
#
#  Args:
#	_module -
#	_dir -
#
#>
######################################################################
p6df::modules::js::aliases::init() {
  local _module="$1"
  local _dir="$2"

  p6df::modules::js::aliases::lerna
  p6df::modules::js::aliases::yarn
  p6df::modules::js::aliases::deno

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::js::langmgr::init()
#
#  Environment:	 P6_DFZ_SRC_DIR
#>
######################################################################
p6df::modules::js::langmgr::init() {

  p6df::core::lang::mgr::init "$P6_DFZ_SRC_DIR/nodenv/nodenv" "nod"

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::js::home::symlinks()
#
#  Environment:	 HOME P6_DFZ_SRC_DIR P6_DFZ_SRC_P6M7G8_DOTFILES_DIR
#>
######################################################################
p6df::modules::js::home::symlinks() {

  p6_dir_mk "$P6_DFZ_SRC_DIR/nodenv/nodenv/plugins"
  p6_file_symlink "$P6_DFZ_SRC_DIR/nodenv/node-build" "$P6_DFZ_SRC_DIR/nodenv/nodenv/plugins/node-build"
  p6_file_symlink "$P6_DFZ_SRC_P6M7G8_DOTFILES_DIR/p6df-js/share/.npm" "$HOME/.npm"
  [ -f "$P6_DFZ_SRC_P6M7G8_DOTFILES_DIR/p6df-js/share/.npmrc" ] && p6_file_symlink "$P6_DFZ_SRC_P6M7G8_DOTFILES_DIR/p6df-js/share/.npmrc" "$HOME/.npmrc"
  p6_file_symlink "$P6_DFZ_SRC_P6M7G8_DOTFILES_DIR/p6df-js/share/.yarnrc" "$HOME/.yarnrc"

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
  p6df::core::homebrew::cli::brew::install deno

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
# Function: p6df::modules::js::mcp()
#
#>
######################################################################
p6df::modules::js::mcp() {

  p6_js_npm_global_install "@arvoretech/npm-registry-mcp"

  p6df::modules::anthropic::mcp::server::add "npm-registry" "npx" "-y" "@arvoretech/npm-registry-mcp"
  p6df::modules::openai::mcp::server::add "npm-registry" "npx" "-y" "@arvoretech/npm-registry-mcp"

  p6_return_void
}
######################################################################
#<
#
# Function: p6df::modules::js::vscodes()
#
#>
######################################################################
p6df::modules::js::vscodes() {

  p6df::modules::vscode::extension::install gregorbiswanger.json2ts
  p6df::modules::vscode::extension::install orta.vscode-jest
  p6df::modules::vscode::extension::install wix.vscode-import-cost
  p6df::modules::vscode::extension::install bradgashler.htmltagwrap
  p6df::modules::vscode::extension::install formulahendry.auto-close-tag
  p6df::modules::vscode::extension::install formulahendry.auto-rename-tag
  p6df::modules::vscode::extension::install bradlc.vscode-tailwindcss
  p6df::modules::vscode::extension::install heybourn.headwind
  p6df::modules::vscode::extension::install bourhaouta.tailwindshades

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::js::vscodes::config()
#
#>
######################################################################
p6df::modules::js::vscodes::config() {

  cat <<'EOF'
  "[javascript]": {
    "editor.defaultFormatter": "dbaeumer.vscode-eslint"
  },
  "[typescript]": {
    "editor.defaultFormatter": "dbaeumer.vscode-eslint"
  },
  "[typescriptreact]": {
    "editor.defaultFormatter": "dbaeumer.vscode-eslint"
  },
  "javascript.updateImportsOnFileMove.enabled": "always",
  "jest.runMode": "on-demand",
  "tailwindCSS.emmetCompletions": true,
  "tailwindCSS.lint.invalidConfigPath": "warning",
  "tailwindCSS.lint.invalidTailwindDirective": "warning",
  "tailwindCSS.lint.invalidVariant": "warning",
  "typescript.tsdk": "node_modules/typescript/lib",
  "typescript.format.enable": false,
  "typescript.suggest.autoImports": true,
  "typescript.preferences.importModuleSpecifier": "relative",
  "typescript.referencesCodeLens.enabled": false,
  "typescript.updateImportsOnFileMove.enabled": "always"
EOF

  p6_return_void
}

######################################################################
#<
#
# Function: words npm = p6df::modules::js::profile::mod()
#
#  Returns:
#	words - npm
#
#  Environment:	 NPM_USER
#>
######################################################################
p6df::modules::js::profile::mod() {

  p6_return_words 'npm' '$NPM_USER'
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
  p6_file_lines_remove '^case' '^esac' 'bun was installed successfully to' "$file"
  p6_file_chmod "a+rx" "$file"
  p6_run_code "BUN_INSTALL=$P6_DFZ_SRC_DIR/bun"6 "$file"
  p6_file_rmf "$file"

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
  for ver_major in 22 24 25; do
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

  p6_alias "yd" "yarn deploy"
  p6_alias "yD" "yarn destroy"

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

  p6_alias "db" "deno bundle"
  p6_alias "dc" "deno compile"
  p6_alias "dca" "deno cache"
  p6_alias "dfmt" "deno fmt"
  p6_alias "dh" "deno help"
  p6_alias "dli" "deno lint"
  p6_alias "drn" "deno run"
  p6_alias "drw" "deno run --watch"
  p6_alias "dts" "deno test"
  p6_alias "dup" "deno upgrade"

  p6_return_void
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
    "node -v 2>/dev/null | p6_filter_strip_leading_v")

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
  local name
  name="gha-$(p6_date_fmt__cli -u +%Y%m%d%H%M%S)"

  npm token create \
    --name "$name" \
    --token-description "p6 github actions ci/cd" \
    --bypass-2fa \
    --expires 90 \
    --packages-and-scopes-permission read-write \
    --scopes @pgollucci

  p6_return_void
}


