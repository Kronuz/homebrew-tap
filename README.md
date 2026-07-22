# Kronuz Homebrew

## Formulas


### Eternal Terminal

`et` plus `etctl`, a native control plane for driving backgrounded `et --ctl`
sessions from scripts and agents (a fork of Eternal Terminal, telemetry off).

Just `brew install Kronuz/tap/et`.


### Xapiand

This formula makes it easy to install `xapiand` on any modern OS X system.

Just `brew install Kronuz/tap/xapiand`.

The [project's page](http://Kronuz.github.io/Xapiand) goes into detail about it.


### Nginx

This formula contains Nginx with LUA, headers-more, echo, push-stream and
h264 streaming.

Just `brew install Kronuz/tap/nginx`.


### GTest

this formula installs google tests library.

Just `brew install Kronuz/tap/gtest`.


## To Build Bottles

### Setup (for cross-compile)

```sh
# Configure a Rosetta Homebrew
softwareupdate --install-rosetta --agree-to-license
sudo chown -R $(whoami) /usr/local/share/zsh /usr/local/share/man
arch -x86_64 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Building

```sh
# arm64
cd ~/code/homebrew-tap
# brew tap Kronuz/tap
# brew update
brew install --build-bottle Kronuz/tap/et
brew bottle Kronuz/tap/et
```

```sh
# x86_64
cd ~/code/homebrew-tap
alias ibrew='arch -x86_64 /usr/local/bin/brew'
# ibrew tap Kronuz/tap
# ibrew update
ibrew install --build-bottle Kronuz/tap/et
ibrew bottle Kronuz/tap/et
```

### Releasing

```sh
cd ~/code/homebrew-tap
release="EternalTerminal-v7.0.0-etctl.2"

gh release create $release --title $release --notes ""

for file in *--*.bottle.tar.gz; do; mv "$file" "${file/--/-}"; done
for file in *-*.bottle.tar.gz; do; gh release upload $release $file; done
```

### Other forulas

```sh
brew update
brew install --build-bottle Kronuz/tap/xapiand
brew bottle Kronuz/tap/xapiand
```

```sh
brew update
brew install --build-bottle Kronuz/tap/nginx
brew bottle Kronuz/tap/nginx
```

```sh
brew update
brew install --build-bottle Kronuz/tap/gtest
brew bottle Kronuz/tap/gtest
```


# Copyright

Copyright © 2018-2026 Germán Méndez Bravo (Kronuz)

Code released under the [MIT License](LICENSE).
