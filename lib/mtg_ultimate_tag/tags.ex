defmodule MtgUltimateTag.Tags do
  alias MtgUltimateTag.Card

  @spec get_from_cards([Card.t()]) :: %{String.t() => [Card.t()]}
  def get_from_cards(cards) do
    Enum.reduce(cards, %{}, fn card, acc ->
      Enum.reduce(card.tags || [], acc, fn tag, acc2 ->
        Map.update(acc2, tag, [card], fn existing -> [card | existing] end)
      end)
    end)
  end
end
