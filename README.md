# CryptoRates

This repository serves as example of elixir code produced by me.
Assignment can be looked [here](ASSIGNMENT.md)

# Usage

Run service: 
```
  mix do ecto.create, ecto.migrate
  mix cr.start
```

Run all tests:
```
  MIX_ENV=test mix do ecto.create, ecto.migrate
  mix test
```
