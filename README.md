# Kronuz Homebrew

## Formulas


### Xapiand

This formula makes it easy to install `xapiand` on any modern OS X system.

Just `brew install Kronuz/tap/xapiand`.

The [project's page](http://kronuz.io/Xapiand) goes into detail about it.


### Nginx

This formula contains Nginx with LUA, headers-more, echo, push-stream and
h264 streaming.

Just `brew install Kronuz/tap/nginx`.


### GTest

this formula installs google tests library.

Just `brew install Kronuz/tap/gtest`.


## To Build Bottles

```sh
brew update

brew install --build-bottle Kronuz/tap/xapian
brew bottle Kronuz/tap/xapian

brew install --build-bottle Kronuz/tap/xapiand
brew bottle Kronuz/tap/xapiand

brew install --build-bottle Kronuz/tap/nginx
brew bottle Kronuz/tap/nginx

brew install --build-bottle Kronuz/tap/gtest
brew bottle Kronuz/tap/gtest
```

# Copyright

Copyright © 2018,2019 Germán Méndez Bravo (Kronuz)

Code released under the [MIT License](LICENSE).
