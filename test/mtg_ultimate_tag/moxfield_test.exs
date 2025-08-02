defmodule MtgUltimateTag.MoxfieldTest do
  use ExUnit.Case, async: true

  alias MtgUltimateTag.Moxfield

  @tag :external
  test "returns a list of card names for a valid Moxfield deck URL" do
    url = "https://moxfield.com/decks/QYiCA1lnwEeQVXp_9W6D2g"

    assert {:ok, names} = Moxfield.fetch_card_names_from_url(url)
    assert is_list(names)
    assert Enum.count(names) > 0
    assert Enum.all?(names, &is_binary/1)

    # Pour voir le résultat en dev :
    IO.inspect(names, label: "Cartes récupérées")
  end
end
