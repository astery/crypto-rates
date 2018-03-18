defmodule CryptoRates.Rate do
  defstruct [
    from: nil,
    to: nil,
    rate: 0.0,
    at: nil,
  ]

  @type t :: %__MODULE__{from: String.t, to: String.t, rate: float, at: DateTime.t}
end
