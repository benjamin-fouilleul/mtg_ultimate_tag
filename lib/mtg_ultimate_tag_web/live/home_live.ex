defmodule MtgUltimateTagWeb.HomeLive do
  alias MtgUltimateTag.Decks
  use MtgUltimateTagWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       cards: [],
       deck: nil,
       error: nil,
       url: "",
       loading: false,
       progress: %{current: nil, index: 0, total: 0}
     )}
  end

  # ça fetch
  def handle_event("submit", %{"url" => url}, socket) do
    # Met à jour immédiatement le front avec loading
    send(self(), {:fetch_cards, url})

    {:noreply,
     assign(socket,
       progress: %{current: nil, index: 0, total: 100},
       cards: [],
       loading: true,
       error: nil
     )}
  end

  def handle_info({:fetch_cards, url}, socket) do
    self_pid = self()

    Task.start(fn ->
      callback = fn name, index, total ->
        send(self_pid, {:progress_update, name, index, total})
      end

      case Decks.fetch_from_url(url, callback) do
        {:ok, {deck, cards}} -> send(self_pid, {:cards_loaded, {deck, cards}})
        {:error, _} -> send(self_pid, {:cards_error})
      end
    end)

    {:noreply, socket}
  end

  def handle_info({:progress_update, name, index, total}, socket) do
    {:noreply, assign(socket, progress: %{current: name, index: index, total: total})}
  end

  def handle_info({:cards_loaded, {deck, cards}}, socket) do
    {:noreply,
     assign(socket,
       cards: cards,
       deck: deck,
       loading: false,
       progress: %{current: nil, index: 0, total: 0}
     )}
  end

  def render(assigns) do
    ~H"""
    <div class="p-10 max-w-2xl mx-auto">
      <h1 class="text-4xl font-bold mb-4 text-center">MTG Ultimate Tag</h1>
      <p class="text-lg text-gray-600 mb-8 text-center">
        Structure your deck using tags provided by Scryfall tagger.
      </p>

      <form phx-submit="submit" class="flex gap-2 justify-center">
        <input
          type="text"
          name="url"
          value={@url}
          placeholder="Paste your Moxfield link"
          class="border border-gray-300 px-4 py-2 rounded w-full max-w-md"
        />

        <button type="submit" class="bg-indigo-600 text-white px-4 py-2 rounded">
          GO
        </button>
      </form>

      <%= if @loading do %>
        <div class="fixed inset-0 bg-black bg-opacity-40 z-50 flex items-center justify-center">
          <div class="bg-white p-6 rounded-xl shadow-xl w-full max-w-sm text-center animate-fade-in">
            <div class="flex items-center justify-center gap-2 text-sm text-indigo-600">
              <svg
                class="animate-spin h-5 w-5"
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
              >
                <circle
                  class="opacity-25"
                  cx="12"
                  cy="12"
                  r="10"
                  stroke="currentColor"
                  stroke-width="4"
                />
                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v4a4 4 0 00-4 4H4z" />
              </svg>
              <span class="italic">Resolving triggers...</span>
            </div>

            <p class="text-indigo-600 font-bold mb-4 mt-2">{@progress.current || "..."}</p>

            <% percent =
              if @progress.total > 0 do
                Float.round(@progress.index / @progress.total * 100, 0)
              else
                0
              end %>

            <div class="w-full h-4 bg-gray-200 rounded-full overflow-hidden mb-2">
              <div
                class="h-full bg-indigo-500 transition-all duration-300 ease-out"
                style={"width: #{percent}%"}
              >
              </div>
            </div>

            <p class="text-sm text-gray-500 tracking-wide">
              {@progress.index} / {@progress.total} cards
            </p>
          </div>
        </div>
      <% end %>

      <%= if Enum.any?(@cards) do %>
        <p class="text-lg mt-8 mb-2">{@deck.name}</p>
        <div class="mt-8 space-y-6">
          <%= for card <- @cards do %>
            <div class="bg-white p-4 rounded-xl shadow flex flex-col gap-2">
              <p class="font-semibold text-lg text-gray-800">{card.name}</p>
              <div class="flex flex-wrap gap-2">
                <%= for tag <- card.tags do %>
                  <span class="bg-indigo-100 text-indigo-700 text-sm px-3 py-1 rounded-full">
                    {tag}
                  </span>
                <% end %>
              </div>
            </div>
          <% end %>
        </div>
      <% end %>
    </div>
    """
  end
end
