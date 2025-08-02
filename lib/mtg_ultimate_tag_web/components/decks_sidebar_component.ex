defmodule MtgUltimateTagWeb.DeckSidebarComponent do
  use Phoenix.Component

  @doc """
  Composant affichant une sidebar avec des decks (images uniquement).
  """
  def deck_sidebar(assigns) do
    ~H"""
    <aside class="group w-28 hover:w-96 bg-gray-100 h-screen fixed left-0 top-0 flex flex-col pt-4 space-y-4 transition-all duration-300 overflow-hidden items-center hover:items-start">
      <%= for deck <- @decks do %>
        <div class="flex items-center space-x-3 px-4 w-full cursor-pointer transition-all duration-300 group-hover:pr-6">
          <!-- Cercle parfaitement centré avec marges égales -->
          <div class="w-20 h-20 rounded-full overflow-hidden border border-gray-300 shadow-sm flex-shrink-0">
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
          
    <!-- Nom du deck (visible seulement quand élargi) -->
          <div class="text-sm font-medium text-gray-800 opacity-0 group-hover:opacity-100 transition-opacity truncate">
            {deck["name"]}
          </div>
        </div>
      <% end %>
    </aside>
    """
  end
end
