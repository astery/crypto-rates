# CryptoRates

This repository serves as example of elixir code produced by me.
Assignment can be looked [here](ASSIGNMENT.md)

# Usage

Run service: 
```
  mix do ecto.create, ecto.migrate
  mix cr.start
  # in separate shell
  curl http://localhost:4000/api/calc?from=BTC&to=USD&amount=1000
```

Run all tests:
```
  MIX_ENV=test mix do ecto.create, ecto.migrate
  mix test
```
