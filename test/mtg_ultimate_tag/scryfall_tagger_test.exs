defmodule MtgUltimateTag.ScryfallTaggerTest do
  use ExUnit.Case, async: true
  alias MtgUltimateTag.ScryfallTagger

  test "fetches tags for Deep Analysis (TDC 150)" do
    set = "tdc"
    collector_number = "150"

    result = ScryfallTagger.get_scryfall_tags(set, collector_number)

    assert {:ok, tags} = result
    assert is_list(tags)
    assert Enum.any?(tags)
    assert Enum.any?(tags, &String.contains?(&1, "card advantage"))

    IO.inspect(tags, label: "✅ Tags for Deep Analysis (TDC 150)")
  end
end
