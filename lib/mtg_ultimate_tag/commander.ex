defmodule MtgUltimateTag.Commander do
  @moduledoc """
  Représente une carte Magic avec les infos pertinentes pour l'affichage front.
  """

  @enforce_keys [:id, :name]
  defstruct [:id, :name]

  @type t :: %__MODULE__{
          id: String.t(),
          name: String.t()
        }
end
