defmodule MtgUltimateTag.Cards do
  @moduledoc """
  Contexte pour récupérer et enrichir les cartes Magic à partir d'un deck Moxfield.
  """
  alias MtgUltimateTag.ScryfallTagger
  alias MtgUltimateTag.Card

  def fetch_tags(results, progress_callback) do
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
