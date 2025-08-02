defmodule MtgUltimateTag.Cards do
  @moduledoc """
  Contexte pour récupérer et manipuler les cartes Magic.
  """

  alias MtgUltimateTag.{Moxfield, Scryfall}
  alias MtgUltimateTag.Card
  @spec get_list(String.t()) :: {:ok, [Card.t()]} | {:error, term()}
  def get_list(deck_url) do
    with {:ok, card_names} <- Moxfield.fetch_card_names_from_url(deck_url) do
      card_names
      |> Enum.chunk_every(75)
      |> Enum.map(&Scryfall.get_cards_data/1)
      |> fetch_tags()
    else
      error -> error
    end
  end

  defp fetch_tags(results) do
    case Enum.reduce_while(results, {:ok, []}, fn
           {:ok, cards}, {:ok, acc} ->
             {:cont, {:ok, acc ++ cards}}

           {:error, _} = err, _acc ->
             {:halt, err}
         end) do
      {:ok, cards_data} ->
        enriched_cards =
          Enum.map(cards_data, fn card ->
            IO.inspect(card)

            tags =
              case MtgUltimateTag.ScryfallTagger.get_scryfall_tags(
                     card.set,
                     card.collector_number
                   ) do
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
    end
  end
end
