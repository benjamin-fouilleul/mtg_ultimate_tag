defmodule MtgUltimateTagWeb.DeckSidebarComponent do
  use Phoenix.Component

  @doc """
  Component that displays a sidebar with the current deck and other available decks.
  """
  def deck_sidebar(assigns) do
    ~H"""
    <aside class="group w-16 hover:w-72 bg-gray-100 h-screen fixed left-0 top-0 flex flex-col transition-all duration-300 overflow-hidden hover:items-start pt-16 p-2">
      
    <!-- Other decks (exclude current) -->
      <%= for deck <- @decks, deck["id"] != @deck["id"] do %>
        <div class="mt-2 flex items-center space-x-3 w-full cursor-pointer transition-all duration-300 group-hover:pr-6">
          
    <!-- Circular commander image -->
          <div class="w-12 h-12 rounded-full overflow-hidden border border-gray-300 shadow-sm flex-shrink-0">
            <img
              src={
                case Enum.at(deck["commanders"] || [], 0) do
                  %{"id" => id} -> "https://assets.moxfield.net/cards/card-#{id}-normal.webp"
                  _ -> "/images/fallback.jpg"
                end
              }
              alt={deck["name"]}
              class="object-cover object-top w-full h-full transform scale-[1.65] translate-y-[5%]"
            />
          </div>
          
    <!-- Deck name (only visible on sidebar hover) -->
          <div class="text-sm font-medium text-gray-800 opacity-0 group-hover:opacity-100 transition-opacity truncate">
            {deck["name"]}
          </div>
        </div>
      <% end %>
      
    <!-- Add deck button (shows label on hover) -->
      <div class="mt-2 flex items-center space-x-3 w-full transition-all duration-300 group-hover:pr-6">
        <button
          type="button"
          class="w-12 h-12 min-w-12 min-h-12 flex items-center justify-center rounded-full bg-white shadow border hover:bg-gray-200 transition text-xl leading-none"
          onclick="alert('bientôt disponible')"
          title="Ajouter un deck"
        >
          <span class="inline-block translate-y-[-1px]">+</span>
        </button>

        <div class="text-sm font-medium text-gray-800 opacity-0 group-hover:opacity-100 transition-opacity truncate">
          Ajouter un autre deck
        </div>
      </div>
    </aside>
    """
  end
end
