defmodule MtgUltimateTag.ScryfallTaggerTest do
  use ExUnit.Case, async: true
  alias MtgUltimateTag.ScryfallTagger

  test "fetches tags for Red Dragon (AFR 160)" do
    set = "afr"
    collector_number = "160"

    result = ScryfallTagger.get_scryfall_tags(set, collector_number)

    assert {:ok, tags} = result
    assert is_list(tags)
    assert Enum.any?(tags)
    assert Enum.any?(tags, &String.contains?(&1, "burn"))

    IO.inspect(tags, label: "✅ Tags for Red Dragon (AFR 160)")
  end
end
