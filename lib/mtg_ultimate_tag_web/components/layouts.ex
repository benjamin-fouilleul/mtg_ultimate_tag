defmodule MtgUltimateTagWeb.Layouts do
  @moduledoc """
  This module holds different layouts used by your application.

  See the `layouts` directory for all templates available.
  The "root" layout is a skeleton rendered as part of the
  application router. The "app" layout is set as the default
  layout on both `use MtgUltimateTagWeb, :controller` and
  `use MtgUltimateTagWeb, :live_view`.
  """
  use MtgUltimateTagWeb, :html

  embed_templates "layouts/*"
end
