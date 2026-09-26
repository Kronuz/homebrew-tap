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

Bump `version`, `branch`, `revision` and the `bottle do` block in
`Formula/et.rb` first; the formula pins a revision, so published artifacts stay
valid even after the branch moves.

```sh
# arm64
cd ~/code/homebrew-tap
brew uninstall --force et
brew install --build-bottle Kronuz/tap/et
brew bottle --no-rebuild Kronuz/tap/et
```

**Unlink the x86 `abseil` before an arm64 build.** The Rosetta Homebrew installs
its headers into `/usr/local/include`, which clang searches by default, so an
arm64 vcpkg build picks up x86 headers and fails while compiling protobuf:

```sh
arch -x86_64 /usr/local/bin/brew unlink abseil   # before arm64
arch -x86_64 /usr/local/bin/brew link abseil     # to build x86 again
```

```sh
# x86_64
cd ~/code/homebrew-tap
alias ibrew='arch -x86_64 /usr/local/bin/brew'
ibrew uninstall --force et
ibrew install --build-bottle Kronuz/tap/et
ibrew bottle --no-rebuild Kronuz/tap/et
```

Homebrew now treats x86_64 macOS as a
[Tier 3 configuration](https://docs.brew.sh/Support-Tiers#tier-3) and no longer
publishes bottles for the dependencies, so `ibrew install` refuses with *"the
following formulae cannot be installed from bottles and must be built from
source"*. Build them once, from source, and the bottle step works afterward
(this takes roughly an hour, mostly `openssl@3`, `curl` and `protobuf`):

```sh
for dep in automake pkgconf libnghttp2 libnghttp3 openssl@3 libngtcp2 \
           libssh2 lz4 xz curl protobuf; do
    ibrew install --build-from-source "$dep"
done
```

### Building the Linux RPM

Built on the dev VM; see `~/Development/LinkedIn/setup/vm.md` for the cmake
invocation and how to fetch the result back over an `etctl` tunnel.

### Releasing

```sh
cd ~/code/homebrew-tap
release="EternalTerminal-v7.0.0-etctl.9"

gh auth switch --user Kronuz    # public repo: never release as the work account
gh release create $release --title $release --notes-file notes.md

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

Keep build artifacts out of the repo. `.gitignore` covers `*.bottle.tar.gz` and
`*.rpm`, because bottling leaves them in the working copy and a `git add -A`
will otherwise commit a few megabytes of binaries.

### Verifying a release

Confirm the same bytes in all three places (local build, published asset,
formula) and that both bottles actually pour:

```sh
release="EternalTerminal-v7.0.0-etctl.9"
base="https://github.com/Kronuz/homebrew-tap/releases/download/$release"
for f in et-*.bottle.tar.gz et-*.x86_64.rpm; do
    curl -sSL -o "/tmp/$f" "$base/$f"
    shasum -a 256 "/tmp/$f" "$f"
done
grep sha256 Formula/et.rb

brew uninstall --force et && brew install Kronuz/tap/et    # expect "Pouring"
ibrew uninstall --force et && ibrew install Kronuz/tap/et  # expect "Pouring"
```

`brew audit --strict` reports that `et1.cmd` is a non-executable in `bin`. That
comes from upstream's install list (it is the Windows launcher) and does not
block the release.

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
