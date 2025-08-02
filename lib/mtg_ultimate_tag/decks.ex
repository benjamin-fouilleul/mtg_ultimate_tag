defmodule MtgUltimateTag.Decks do
  @moduledoc """
  Opération autour des decks
  """

  alias MtgUltimateTag.Scryfall
  alias MtgUltimateTag.Moxfield
  alias MtgUltimateTag.Cards

  @type progress_callback :: (String.t(), non_neg_integer(), non_neg_integer() -> any())

  def fetch_from_url(deck_url, progress_callback \\ fn _, _, _ -> :ok end) do
    with {:ok, {deck, cards}} <- Moxfield.fetch_deck_from_url(deck_url),
         {:ok, cards_with_tags} <-
           cards
           |> Enum.chunk_every(75)
           |> Enum.map(&Scryfall.get_cards_data/1)
           |> Cards.fetch_tags(progress_callback) do
      {:ok, {deck, cards_with_tags}}
    else
      error -> error
    end
  end
end
