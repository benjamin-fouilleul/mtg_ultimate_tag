defmodule MtgUltimateTag.ScryfallTagger do
  @moduledoc """
  Appelle le microservice externe pour récupérer les tags d'une carte MTG.
  """

  @doc """
  Récupère les tags d'une carte (set + numéro) via l'API Node.
  Retourne {:ok, [tags]} ou {:error, reason}.
  """
  @spec get_scryfall_tags(String.t(), String.t()) :: {:ok, [String.t()]} | {:error, term()}
  def get_scryfall_tags(set, collector_number) do
    url = "#{tagger_base_url()}/tags?set=#{set}&number=#{collector_number}"

    case HTTPoison.get(url, [], recv_timeout: 5000) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        case Jason.decode(body) do
          {:ok, tags} when is_list(tags) -> {:ok, tags}
          _ -> {:error, :invalid_json}
        end

      {:ok, %HTTPoison.Response{status_code: code}} ->
        {:error, {:http_error, code}}

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp tagger_base_url do
    Application.fetch_env!(:mtg_ultimate_tag, :tagger_scraper_url)
  end
end
