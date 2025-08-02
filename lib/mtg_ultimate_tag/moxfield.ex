defmodule MtgUltimateTag.Moxfield do
  @moduledoc """
  Interaction avec l'API Moxfield pour récupérer les cartes d'un deck.
  """

  # URL de base pour accéder à l'API de Moxfield
  @api_base "https://api.moxfield.com/v2/decks/all"

  # Fonction principale appelée depuis le front
  def fetch_card_names_from_url(url) do
    with {:ok, deck_id} <- extract_deck_id(url),
         {:ok, json} <- fetch_deck_json(deck_id),
         {:ok, card_names} <- get_card_names_from_json(json) do
      {:ok, card_names}
    else
      # Renvoie une erreur générique
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

  # Pas le bon format
  defp get_card_names_from_json(_), do: {:error, :invalid_json}
end
