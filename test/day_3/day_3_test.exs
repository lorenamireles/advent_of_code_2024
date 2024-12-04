defmodule AdventOfCode2024.Day3Test do
  use ExUnit.Case

  alias AdventOfCode2024.Day3

  describe "remove_invalid_mul_blocks/1" do
    test "receives an input  and returns two separated lists" do
      input = ["xmul(2,4)don't()_mul(5,5)+mul(32,64]do()8)undo()?mul(8,5))don't()+mul23,do()"]
      expected = ["xmul(2,4)invalid_section8)undo()?mul(8,5))invalid_section"]

      response = Day3.remove_invalid_mul_blocks(input)

      assert response == expected
    end
  end
end
