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
release="EternalTerminal-v7.0.0-etctl.7"

gh release create $release --title $release --notes ""

for file in *--*.bottle.tar.gz; do; mv "$file" "${file/--/-}"; done
for file in *-*.bottle.tar.gz; do; gh release upload $release $file; done

# The RPM, plus an unversioned alias so the articles can link a URL that
# never needs bumping:
#   .../releases/latest/download/et-latest.x86_64.rpm
# dnf reads the version from the package header, not the file name, so the
# alias still installs (and upgrades to) the right build.
gh release upload $release et-*.x86_64.rpm
cp et-*.x86_64.rpm et-latest.x86_64.rpm
gh release upload $release et-latest.x86_64.rpm
```

Upload the alias on **every** release, since `latest` follows the newest
release in this repo. That also means the `latest` URL only stays correct while
EternalTerminal is the only formula released here: cutting a release for
`xapiand` or `nginx` would take `latest` with it, and the alias would have to be
attached to that release too (or the ET releases moved to their own repo).

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
