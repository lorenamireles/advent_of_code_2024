defmodule AdventOfCode2024.Day1 do
  @moduledoc """
  Advent of Code 2024: Day 1 - Historian Hysteria

  https://adventofcode.com/2024/day/1
  """

  @doc """
  Function to execute the first part of the exercise.

  ## Examples

      iex> AdventOfCode2024.Day1.part_1()
      iex> 7

  Update the path with the location of your input file.
  """
  @spec part_1() :: integer()
  def part_1 do
    path = "/your_path/your_input.txt"

    path
    |> get_input
    |> define_separated_lists()
    |> sum_distance_list_items()
  end

  @doc """
  Function to execute the second part of the exercise.

  ## Examples

      iex> AdventOfCode2024.Day1.part_2()
      iex> 31

  Update the path with the location of your input file.
  """
  @spec part_2() :: integer
  def part_2 do
    path = "/your_path/your_input.txt"

    path
    |> get_input
    |> define_separated_lists()
    |> multiply_frequencies()
  end

  @doc """
  Receives a path corresponding to a .txt file with the exercise input,
  reads it and applies the necessary transformations.
  """
  @spec get_input(String.t()) :: list()
  def get_input(path) do
    path
    |> File.read!()
    |> String.split("\n", trim: true)
  end

  @doc """
  This function takes a list where the elements are strings with two
  components separated by whitespace.

  Example: "3   4"

  It assigns the first element to list one and the second to list two,
  assuming both are numbers.
  """
  @spec define_separated_lists(list()) :: map()
  def define_separated_lists(input) do
    Enum.reduce(input, %{first_list: [], second_list: []}, fn row, map_with_lists ->
      [elem_first_list, elem_second_list] = String.split(row, "   ")

      %{
        first_list: [String.to_integer(elem_first_list) | map_with_lists.first_list],
        second_list: [String.to_integer(elem_second_list) | map_with_lists.second_list]
      }
    end)
  end

  @doc """
  This function receives a map with two lists, sorts them from smallest
  to largest, calculates the distance between the elements of each and
  returns the sum.

  For example, for the following lists: list_1 = [1,3,5] list_2 = [4,5,6]

  The distances are: [3, 2, 1] respectively. So the final result is 6.
  """
  @spec sum_distance_list_items(map()) :: integer()
  def sum_distance_list_items(%{first_list: first_list, second_list: second_list} = _input) do
    first_sorted_list = Enum.sort(first_list)
    second_sorted_list = Enum.sort(second_list)

    first_sorted_list
    |> Enum.zip_with(second_sorted_list, fn x, y -> abs(x - y) end)
    |> Enum.reduce(0, fn distance, acc -> distance + acc end)
  end

  @doc """
  This function receives two lists. It checks how many times each element of
  the first list appears in the second list and multiplies their frequencies.
  """
  @spec multiply_frequencies(map()) :: integer()
  def multiply_frequencies(%{first_list: first_list, second_list: second_list} = _input) do
    frequencies_second_list = Enum.frequencies(second_list)

    Enum.reduce(first_list, 0, fn elem, acc ->
      elem * Map.get(frequencies_second_list, elem, 0) + acc
    end)
  end
end
