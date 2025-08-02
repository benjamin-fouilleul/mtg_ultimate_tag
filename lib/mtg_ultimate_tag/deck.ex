defmodule MtgUltimateTag.Deck do
  @moduledoc """
  Représente un deck Magic
  """
  alias MtgUltimateTag.Commander

  @derive {Jason.Encoder, only: [:id, :name, :commanders]}
  @enforce_keys [:id, :name, :commanders]
  defstruct [:id, :name, :commanders]

  @type t :: %__MODULE__{
          id: String.t(),
          name: String.t(),
          commanders: [Commander.t()]
        }
end
