defmodule MtgUltimateTag.ScryfallTest do
  use ExUnit.Case
  alias MtgUltimateTag.Scryfall

  @tag :external
  test "fetches multiple cards via collection API" do
    card_names = ["Red Dragon", "Deep Analysis", "Frostcliff Siege"]

    case Scryfall.get_cards_data(card_names) do
      {:ok, cards} ->
        assert length(cards) == 3
        IO.puts("✅ Cartes récupérées :")

        Enum.each(cards, fn card ->
          IO.inspect(card)
        end)

      {:error, reason} ->
        IO.puts("❌ Erreur: #{inspect(reason)}")
        flunk("Échec de récupération des cartes")
    end
  end
end
