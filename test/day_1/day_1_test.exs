defmodule AdventOfCode2024.Day1Test do
  use ExUnit.Case

  alias AdventOfCode2024.Day1

  describe "define_separated_lists/1" do
    test "receives an input  and returns two separated lists" do
      input = ["3   4", "4   3", "2   5", "1   3", "3   9", "3   3"]

      response = Day1.define_separated_lists(input)

      expected = %{
        first_list: [3, 3, 1, 2, 4, 3],
        second_list: [3, 9, 3, 5, 3, 4]
      }

      assert response == expected
    end

    test "returns a map with empty lists for empty input" do
      assert %{first_list: [], second_list: []} == Day1.define_separated_lists([])
    end
  end

  describe "sum_distance_list_items/1" do
    test "receives two lists and calculates the distance between their elements one by one" do
      input = %{first_list: [1, 3, 5], second_list: [4, 5, 6]}

      response = Day1.sum_distance_list_items(input)
      expected = 6

      assert response == expected
    end

    test "returns zero for a map with empty lists" do
      assert 0 == Day1.sum_distance_list_items(%{first_list: [], second_list: []})
    end
  end

  describe "multiply_frequencies/1" do
    test "receives two lists and multiplies the number of times an element of the first appears in the second" do
      input = %{first_list: [1, 3, 5], second_list: [4, 5, 6]}

      response = Day1.multiply_frequencies(input)
      expected = 5

      assert response == expected
    end

    test "returns zero for a map with empty lists" do
      assert 0 == Day1.multiply_frequencies(%{first_list: [], second_list: []})
    end
  end
end
