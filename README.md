# Kronuz Homebrew tap

[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

Homebrew formulas for Germán Méndez Bravo's tools: one `brew tap`, then install by
name. Bottles are prebuilt for Apple silicon and Intel where noted.

```sh
brew tap Kronuz/tap
brew install Kronuz/tap/et
```

## 🍺 Formulas

| Formula | What it is | Bottles |
|---|---|---|
| [`et`](Formula/et.rb) | Eternal Terminal fork with `etctl`, a control plane for driving backgrounded sessions from scripts and agents; telemetry off | macOS 26: arm64, x86_64 |
| [`xapiand`](Formula/xapiand.rb) | [Xapiand](https://github.com/Kronuz/Xapiand), a RESTful search and storage engine | macOS 14-15 arm64, macOS 14 x86_64; built per release |
| [`detent`](Formula/detent.rb) | [Detent](https://kronuz.github.io/Detent/) runtime knobs: `detentd`, `detent-agent`, and `detent` | source |
| [`nginx`](Formula/nginx.rb) | nginx 1.15 with Lua, headers-more, echo, push-stream, and H.264 streaming | source |
| [`gtest`](Formula/gtest.rb) | Google Test 1.8 | source |
| [`xapian`](Formula/xapian.rb) | The Xapian fork older Xapiand releases linked; current Xapiand bundles it | source |

`nginx`, `gtest`, and `xapian` are legacy formulas, kept for old setups and not
updated.

## 🔄 Updating

```sh
brew update && brew upgrade Kronuz/tap/et
```

`brew install --HEAD Kronuz/tap/<formula>` builds from the latest source where the
formula has a `head`.

## 📚 Documentation

- [docs/RELEASING.md](docs/RELEASING.md): building bottles on both architectures,
  publishing a release, and verifying it.

## 🤝 Contributing

Issues and pull requests are welcome. Run `brew audit --strict Kronuz/tap/<formula>`
before sending a formula change.

## 📄 License

MIT, Copyright © 2018-2026 Germán Méndez Bravo (Kronuz). See [LICENSE](LICENSE).
