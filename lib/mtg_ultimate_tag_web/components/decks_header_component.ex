defmodule MtgUltimateTagWeb.DeckHeaderComponent do
  use Phoenix.Component

  @doc """
  Component that displays a top header with the current deck's name and commander image.
  Only visible if a deck is selected.
  """
  def deck_header(assigns) do
    ~H"""
    <%= if @deck do %>
      <% commander = Enum.at(@deck["commanders"] || [], 0)
      commander_id = commander && commander["id"]

      commander_image =
        if commander_id do
          "https://assets.moxfield.net/cards/card-#{commander_id}-normal.webp"
        else
          "/images/fallback.jpg"
        end %>

      <header class="fixed top-0 left-0 right-0 h-16 flex items-center text-xl font-semibold shadow bg-white z-40 animate-slide-down">
        <!-- Current deck's commander image -->
        <div class="w-16 h-16 overflow-hidden flex-shrink-0 mr-6">
          <img
            src={commander_image}
            alt={@deck["name"]}
            class="object-cover object-top w-full h-full transform scale-[1.80] translate-y-[5%]"
          />
        </div>
        
    <!-- Deck name -->
        <h1 class="truncate">{@deck["name"]}</h1>
      </header>
    <% end %>
    """
  end
end
