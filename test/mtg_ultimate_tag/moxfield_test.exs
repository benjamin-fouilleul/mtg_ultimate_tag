defmodule MtgUltimateTag.MoxfieldTest do
  use ExUnit.Case, async: true

  alias MtgUltimateTag.Moxfield

  @tag :external
  test "returns a Deck struct with name and cards for a valid Moxfield deck URL" do
    {:ok, deck} =
      Moxfield.fetch_deck_from_url("https://moxfield.com/decks/QYiCA1lnwEeQVXp_9W6D2g")

    IO.inspect(deck)
    assert %MtgUltimateTag.Deck{} = deck
    assert deck.name == "Shiko and Narset, Unified"
    assert is_list(deck.cards)
    assert "Red Dragon" in deck.cards
  end
end
