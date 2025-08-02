defmodule MtgUltimateTagWeb.DeckLive do
  use MtgUltimateTagWeb, :live_view
  import MtgUltimateTagWeb.DeckSidebarComponent

  def mount(%{"deck_id" => deck_id}, _session, socket) do
    {:ok, assign(socket, deck_id: deck_id)}
  end

  def render(assigns) do
    ~H"""
    <.deck_sidebar decks={[
      %{name: "Mono Black Control", image_url: "/images/mbc.jpg"},
      %{name: "Simic Ramp", image_url: "/images/simic.jpg"},
      %{name: "Rakdos Midrange", image_url: "/images/rakdos.jpg"}
    ]} />

    <main class="ml-24 p-10">
      <h1 class="text-3xl font-bold mb-4">Deck page: {@deck_id}</h1>
      <p class="text-gray-600">This is the future home of your deck data.</p>
    </main>
    """
  end
end
