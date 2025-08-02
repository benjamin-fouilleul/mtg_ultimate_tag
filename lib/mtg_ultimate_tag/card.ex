defmodule MtgUltimateTag.Card do
  @moduledoc """
  Représente une carte Magic avec les infos pertinentes pour l'affichage front.
  """

  @derive {Jason.Encoder, only: [:id, :name, :set, :collector_number, :tags]}
  @enforce_keys [:id, :name, :set, :collector_number, :tags]
  defstruct [:id, :name, :set, :collector_number, :tags]

  @type t :: %__MODULE__{
          id: String.t(),
          name: String.t(),
          set: String.t(),
          collector_number: String.t(),
          tags: [String.t()]
        }
end
