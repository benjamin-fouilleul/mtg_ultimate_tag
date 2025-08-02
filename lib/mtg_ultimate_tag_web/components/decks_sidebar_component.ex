defmodule MtgUltimateTagWeb.DeckSidebarComponent do
  use Phoenix.Component

  @doc """
  Composant affichant une sidebar avec des decks (images uniquement).
  """
  def deck_sidebar(assigns) do
    ~H"""
    <aside class="w-24 bg-gray-100 h-screen fixed left-0 top-0 flex flex-col items-center pt-6 space-y-4">
      <%= for deck <- @decks do %>
        <div class="group relative w-16 h-24 overflow-hidden rounded shadow-md cursor-pointer transition duration-300 hover:w-64 hover:h-36 hover:z-10 hover:shadow-xl">
          <img
            src={deck.image_url}
            alt={deck.name}
            class="object-cover w-full h-full transition-transform duration-300 group-hover:scale-105"
          />

          <div class="absolute bottom-0 left-0 right-0 bg-black bg-opacity-60 text-white text-sm text-center py-1 opacity-0 group-hover:opacity-100 transition-opacity">
            {deck.name}
          </div>
        </div>
      <% end %>
    </aside>
    """
  end
end
