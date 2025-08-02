defmodule MtgUltimateTag.Deck do
  @moduledoc """
  Représente un deck Magic
  """

  @enforce_keys [:id, :name]
  defstruct [:id, :name]

  @type t :: %__MODULE__{
          id: String.t(),
          name: String.t()
        }
end
