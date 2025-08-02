defmodule MtgUltimateTag.Tag do
  @moduledoc """
  Représente une carte Magic avec les infos pertinentes pour l'affichage front.
  """

  @derive {Jason.Encoder, only: [:id, :name, :set, :scryfall_tag]}
  @enforce_keys [:id, :name, :set, :scryfall_tag]
  defstruct [:id, :name, :set, :scryfall_tag]

  @type t :: %__MODULE__{
          id: String.t(),
          name: String.t(),
          scryfall_tag: String.t()
        }
end
