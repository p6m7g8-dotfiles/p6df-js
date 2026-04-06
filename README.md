# P6's POSIX.2: p6df-js

## Table of Contents

- [Badges](#badges)
- [Summary](#summary)
- [Contributing](#contributing)
- [Code of Conduct](#code-of-conduct)
- [Usage](#usage)
  - [Aliases](#aliases)
  - [Functions](#functions)
- [Hierarchy](#hierarchy)
- [Author](#author)

## Badges

[![License](https://img.shields.io/badge/License-Apache%202.0-yellowgreen.svg)](https://opensource.org/licenses/Apache-2.0)

## Summary

TODO: Add a short summary of this module.

## Contributing

- [How to Contribute](<https://github.com/p6m7g8-dotfiles/.github/blob/main/CONTRIBUTING.md>)

## Code of Conduct

- [Code of Conduct](<https://github.com/p6m7g8-dotfiles/.github/blob/main/CODE_OF_CONDUCT.md>)

## Usage

### Aliases

- `db` -> `deno bundle`
- `dc` -> `deno compile`
- `dca` -> `deno cache`
- `dfmt` -> `deno fmt`
- `dh` -> `deno help`
- `dli` -> `deno lint`
- `drn` -> `deno run`
- `drw` -> `deno run --watch`
- `dts` -> `deno test`
- `dup` -> `deno upgrade`
- `lb` -> `lr build`
- `lr` -> `lerna run --stream --scope $(node -p 'require(\'./package.json\').name\')`
- `lt` -> `lr test`
- `lw` -> `lr watch`
- `yd` -> `yarn deploy`
- `yD` -> `yarn destroy`

### Functions

#### p6df-js

##### p6df-js/init.zsh

- `p6df::modules::js::aliases::deno()`
- `p6df::modules::js::aliases::init(_module, _dir)`
  - Args:
    - _module
    - _dir
- `p6df::modules::js::aliases::lerna()`
- `p6df::modules::js::aliases::yarn()`
- `p6df::modules::js::completions::init(_module, dir)`
  - Args:
    - _module
    - dir
- `p6df::modules::js::deps()`
- `p6df::modules::js::env::init(_module, _dir)`
  - Args:
    - _module
    - _dir
- `p6df::modules::js::external::brews()`
- `p6df::modules::js::home::symlinks()`
- `p6df::modules::js::langmgr::init()`
- `p6df::modules::js::langs()`
- `p6df::modules::js::langs::bun()`
- `p6df::modules::js::langs::nodenv()`
- `p6df::modules::js::mcp()`
- `p6df::modules::js::npm::token::gha()`
- `p6df::modules::js::vscodes()`
- `p6df::modules::js::vscodes::config()`
- `str str = p6df::modules::js::prompt::lang()`
- `words npm = p6df::modules::js::profile::mod()`

#### p6df-js/lib

##### p6df-js/lib/nodenv.zsh

- `p6df::modules::js::nodenv::latest(ver_major)`
  - Args:
    - ver_major
- `p6df::modules::js::nodenv::latest::installed(ver_major)`
  - Args:
    - ver_major

##### p6df-js/lib/npm.zsh

- `p6_js_npm_global_install(mod)`
  - Args:
    - mod

## Hierarchy

```text
.
├── init.zsh
├── lib
│   ├── nodenv.zsh
│   └── npm.zsh
├── README.md
└── share

3 directories, 4 files
```

## Author

Philip M. Gollucci <pgollucci@p6m7g8.com>
