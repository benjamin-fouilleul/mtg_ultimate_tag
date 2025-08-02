defmodule MtgUltimateTagWeb.HomeLive do
  alias MtgUltimateTag.Cards
  use MtgUltimateTagWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, cards: [], error: nil, url: "", loading: false)}
  end

  # ça fetch
  def handle_event("submit", %{"url" => url}, socket) do
    # Met à jour immédiatement le front avec loading
    send(self(), {:fetch_cards, url})
    {:noreply, assign(socket, loading: true, cards: [], error: nil)}
  end

  def handle_info({:fetch_cards, url}, socket) do
    case Cards.get_list(url) do
      {:ok, cards} ->
        {:noreply, assign(socket, cards: cards, error: nil, loading: false)}

      {:error, _} ->
        {:noreply, assign(socket, cards: [], error: "Deck introuvable", loading: false)}
    end
  end

  def render(assigns) do
    ~H"""
    <div class="p-10 max-w-xl mx-auto">
      <h1 class="text-4xl font-bold mb-4 text-center">MTG Ultimate Tag</h1>
      <p class="text-lg text-gray-600 mb-8 text-center">
        Fini les decks en vrac.<br /> Collez votre lien, on s’occupe du reste !
      </p>

      <form phx-submit="submit" class="flex gap-2 justify-center">
        <input
          type="text"
          name="url"
          value={@url}
          placeholder="Collez le lien vers votre deck"
          class="border border-gray-300 px-4 py-2 rounded w-full max-w-md"
        />

        <button type="submit" class="bg-indigo-600 text-white px-4 py-2 rounded">
          GO
        </button>
      </form>

      <%= if @loading do %>
        <div class="flex items-center justify-center gap-2 mt-6 text-sm text-indigo-600">
          <svg
            class="animate-spin h-5 w-5"
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 24 24"
          >
            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4" />
            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v4a4 4 0 00-4 4H4z" />
          </svg>
          <span class="italic">Invocation du deck...</span>
        </div>
      <% end %>

      <%= if Enum.any?(@cards) do %>
        <p class="text-lg mt-8 mb-2">Cartes trouvées</p>
        <ul class="list-disc ml-6">
          <%= for card <- @cards do %>
            <li class="text-gray-600">{card.name}</li>
          <% end %>
        </ul>
      <% end %>
    </div>
    """
  end
end
