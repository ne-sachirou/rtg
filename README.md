RTG
==

起動する。

```sh
brew services start mysql
brew services start redis
mix rtg.setup
iex -S mix phx.server
```

Testする。

```sh
mix cotton.lint
mix coveralls
```

codeの変更を適用する。

```sh
mix do rtg.format, compile
```

LICENSE
--
AGPL-3.0-or-later
