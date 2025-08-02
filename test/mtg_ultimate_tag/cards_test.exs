defmodule MtgUltimateTag.CardsTest do
  use ExUnit.Case, async: true

  alias MtgUltimateTag.Cards
  alias MtgUltimateTag.Card

  @deck_url "https://moxfield.com/decks/QYiCA1lnwEeQVXp_9W6D2g"

  test "get_list/1 returns enriched cards from Moxfield deck" do
    result = Cards.fetch_list_from_url(@deck_url)

    assert {:ok, cards} = result
    assert is_list(cards)
    assert Enum.all?(cards, &match?(%Card{}, &1))

    Enum.each(cards, fn card ->
      assert is_binary(card.id)
      assert is_binary(card.name)
      assert is_binary(card.set)
      assert is_binary(card.collector_number)
      assert is_list(card.tags)
      assert length(card.tags) > 0, "Expected non-empty tags for card: #{card.name}"
    end)

    # Optionnel : on affiche une des cartes
    IO.inspect(Enum.at(cards, 0), label: "🎴 First card")
  end
end
