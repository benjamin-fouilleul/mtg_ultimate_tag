defmodule MtgUltimateTag.Cards do
  @moduledoc """
  Contexte pour récupérer et enrichir les cartes Magic à partir d'un deck Moxfield.
  """

  alias MtgUltimateTag.{Moxfield, Scryfall, ScryfallTagger}
  alias MtgUltimateTag.Card

  @type progress_callback :: (String.t(), non_neg_integer(), non_neg_integer() -> any())

  @doc """
  Récupère les cartes d'un deck Moxfield, enrichies avec les données Scryfall et les tags.

  Peut accepter un callback pour suivre la progression (nom, index, total).
  """
  @spec get_list(String.t(), progress_callback()) :: {:ok, [Card.t()]} | {:error, term()}
  def get_list(deck_url, progress_callback \\ fn _, _, _ -> :ok end) do
    with {:ok, card_names} <- Moxfield.fetch_card_names_from_url(deck_url) do
      card_names
      |> Enum.chunk_every(75)
      |> Enum.map(&Scryfall.get_cards_data/1)
      |> fetch_tags(progress_callback)
    else
      error -> error
    end
  end

  defp fetch_tags(results, progress_callback) do
    case Enum.reduce_while(results, {:ok, []}, fn
           {:ok, cards}, {:ok, acc} -> {:cont, {:ok, acc ++ cards}}
           {:error, _} = err, _acc -> {:halt, err}
         end) do
      {:ok, cards_data} ->
        total = length(cards_data)

        enriched_cards =
          cards_data
          |> Enum.with_index()
          |> Enum.map(fn {card, idx} ->
            # Callback progress
            progress_callback.(card.name, idx + 1, total)

            tags =
              case ScryfallTagger.get_scryfall_tags(card.set, card.collector_number) do
                {:ok, tags} -> tags
                {:error, _} -> []
              end

            %Card{
              id: card.id,
              name: card.name,
              set: card.set,
              collector_number: card.collector_number,
              tags: tags
            }
          end)

        {:ok, enriched_cards}

      error ->
        error
    end
  end
end
