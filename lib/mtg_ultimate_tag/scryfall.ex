defmodule MtgUltimateTag.Scryfall do
  @moduledoc """
  Module pour interroger l'API Scryfall avec une liste de noms de cartes via /cards/collection.
  """

  @collection_url "https://api.scryfall.com/cards/collection"

  def get_cards_data(card_names) when is_list(card_names) do
    identifiers =
      card_names
      |> Enum.map(&%{"name" => &1})

    body = Jason.encode!(%{"identifiers" => identifiers})
    headers = [{"Content-Type", "application/json"}]

    case HTTPoison.post(@collection_url, body, headers, recv_timeout: 5000) do
      {:ok, %HTTPoison.Response{status_code: 200, body: response_body}} ->
        response_body
        |> Jason.decode!()
        |> Map.get("data", [])
        |> Enum.map(&extract_card_info/1)
        |> then(&{:ok, &1})

      {:ok, %HTTPoison.Response{status_code: code}} ->
        {:error, "Scryfall returned status #{code}"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, "HTTP error: #{inspect(reason)}"}
    end
  end

  defp extract_card_info(card) do
    %{
      id: card["id"],
      name: card["name"],
      set: card["set"],
      collector_number: card["collector_number"]
    }
  end
end
