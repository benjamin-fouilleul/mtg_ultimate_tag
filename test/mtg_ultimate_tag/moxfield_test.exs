defmodule MtgUltimateTag.MoxfieldTest do
  use ExUnit.Case, async: true

  alias MtgUltimateTag.Moxfield

  @tag :external
  test "returns a Deck struct with name and cards for a valid Moxfield deck URL" do
    {:ok, {deck, cards}} =
      Moxfield.fetch_deck_from_url("https://moxfield.com/decks/QYiCA1lnwEeQVXp_9W6D2g")

    IO.inspect(deck)
    IO.inspect([cards[0]])
    assert is_list(deck.commanders)
    assert is_list(cards)
    assert "Red Dragon" in cards
  end
end
