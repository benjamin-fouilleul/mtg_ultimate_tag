defmodule MtgUltimateTag.Moxfield do
  @moduledoc """
  Interaction avec l'API Moxfield pour récupérer les cartes d'un deck.
  """

  # URL de base pour accéder à l'API de Moxfield
  @api_base "https://api.moxfield.com/v2/decks/all"

  # Search deck
  def fetch_deck_from_url(url) do
    with {:ok, deck_id} <- extract_deck_id(url),
         {:ok, deck_data} <- fetch_deck_json(deck_id),
         {:ok, commanders} <- get_commanders_from_json(deck_data),
         {:ok, cards} <- get_card_names_from_json(deck_data) do
      IO.inspect(deck_data)

      deck = %MtgUltimateTag.Deck{
        id: deck_id,
        name: deck_data["name"],
        commanders: commanders
      }

      {:ok, {deck, cards}}
    else
      error -> {:error, error}
    end
  end

  # Extrait l'ID du deck à partir de l'URL
  defp extract_deck_id(url) do
    case Regex.run(~r{/decks/([^/?#]+)}, url) do
      # ID trouvé (tout ce qui suit /decks/)
      [_, id] -> {:ok, id}
      # Pas trouvé
      _ -> {:error, :not_found}
    end
  end

  # Fait un appel HTTP à l'API de Moxfield
  defp fetch_deck_json(deck_id) do
    url = "#{@api_base}/#{deck_id}"

    headers = [
      # Evite les erreurs 403
      {"User-Agent", "Mozilla/5.0 (ElixirBot/1.0)"}
    ]

    case HTTPoison.get(url, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        # JSON décodé ici
        Jason.decode(body)

      {:ok, %HTTPoison.Response{status_code: code}} ->
        # Erreur HTTP
        {:error, {:http_error, code}}

      {:error, reason} ->
        # Erreur réseau
        {:error, reason}
    end
  end

  # Extrait les noms de cartes depuis le JSON
  defp get_card_names_from_json(%{"mainboard" => mainboard}) when is_map(mainboard) do
    names = Map.keys(mainboard)
    # On retourne juste les noms
    {:ok, names}
  end

  # Extrait les commandants depuis le JSON
  def get_commanders_from_json(%{"commanders" => commanders}) do
    commanders_list =
      commanders
      |> Enum.map(fn {name, %{"card" => %{"id" => id}}} ->
        %{id: id, name: name}
      end)

    {:ok, commanders_list}
  end
end
