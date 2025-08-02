defmodule MtgUltimateTagWeb.DeckLive do
  use MtgUltimateTagWeb, :live_view
  import MtgUltimateTagWeb.DeckSidebarComponent
  import MtgUltimateTagWeb.DeckHeaderComponent

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       deck: nil,
       decks: [],
       cards: [],
       tags: []
     )}
  end

  @impl true
  def handle_event(
        "restore",
        %{"deck" => deck, "decks" => decks, "cards" => cards, "tags" => tags},
        socket
      ) do
    {:noreply,
     assign(socket,
       deck: deck,
       decks: decks,
       cards: cards,
       tags: tags
     )}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex min-h-screen">
      <div id="restore" phx-hook="Restore"></div>

      <.deck_header deck={@deck} />
      <.deck_sidebar decks={@decks} deck={@deck} />

      <main class="flex-1 p-6 ml-16 mt-16">
        <div class="space-y-6">
          <%= for card <- @cards do %>
            <div class="bg-white p-4 rounded-xl shadow flex flex-col gap-2">
              <p class="font-semibold text-lg text-gray-800">{card["name"]}</p>
              <div class="flex flex-wrap gap-2">
                <%= for tag <- card["tags"] do %>
                  <span class="bg-indigo-100 text-indigo-700 text-sm px-3 py-1 rounded-full">
                    {tag}
                  </span>
                <% end %>
              </div>
            </div>
          <% end %>
        </div>
      </main>
    </div>
    """
  end
end
