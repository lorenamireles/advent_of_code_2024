defmodule AdventOfCode2024.Day2 do
  @moduledoc """
  Advent of Code 2024: Day 2 - Red-Nosed Reports

  https://adventofcode.com/2024/day/2
  """

  @doc """
  Function to execute the first part of the exercise.

  ## Examples

      iex> AdventOfCode2024.Day2.part_1()
      iex> 2

  Update the path with the location of your input file.
  """
  @spec part_1() :: integer()
  def part_1 do
    path = "/your_path/your_input.txt"

    path
    |> get_input()
    |> get_sorted_level_lists()
    |> get_valid_adjacent_levels()
    |> Enum.count()
  end

  @doc """
  Function to execute the first part of the exercise.

  ## Examples

      iex> AdventOfCode2024.Day2.part_2()
      iex> 4

  Update the path with the location of your input file.
  """
  @spec part_2() :: integer()
  def part_2 do
    path = "/your_path/your_input.txt"

    path
    |> get_input()
    |> get_valid_lists_with_bad_levels()
    |> Enum.count()
  end

  @doc """
  This function receives a list of lists and checks one by one if
  they are valid. If not, it allows you to remove levels and check
  again. At the end, it returns a list with all the options that meet
  the two conditions, either with the original levels or removing one.
  """
  @spec get_valid_lists_with_bad_levels([list()]) :: [list()]
  def get_valid_lists_with_bad_levels(levels) do
    levels
    |> Enum.map(fn level ->
      if is_a_valid_list?(level) do
        level
      else
        remove_level_and_validate_list(level, 0)
      end
    end)
    |> Enum.reject(&(&1 == []))
  end

  @doc """
  This function recursively calculates whether a list is valid by removing
  any of its levels.

  Returns the list that meets both conditions or an empty list otherwise.

  ## Examples

      iex> remove_level_and_validate_list([1, 3, 2, 4, 5], 0)
      iex> [1, 2, 4, 5]

       iex> remove_level_and_validate_list([1, 2, 7, 8, 9], 0)
      iex> []


  Update the path with the location of your input file.
  """
  @spec remove_level_and_validate_list(list(), integer) :: list()
  def remove_level_and_validate_list(level, index) when index == length(level), do: []

  def remove_level_and_validate_list(level, index) do
    new_list = List.delete_at(level, index)

    if is_a_valid_list?(new_list) do
      new_list
    else
      remove_level_and_validate_list(level, index + 1)
    end
  end

  @doc """
  This function takes a list of lists and filters out those that are
  not sorted ascending or descending to meet the first condition:

  - The levels are either all increasing or all decreasing.

  ## Examples

      iex> get_sorted_level_lists([[1, 3, 2, 4, 5], [8, 6, 4, 2, 1]])
      iex> [[8, 6, 4, 2, 1]]
  """
  @spec get_sorted_level_lists([list()]) :: [list()]
  def get_sorted_level_lists(levels),
    do: Enum.filter(levels, &(is_ascending?(&1) || is_descending?(&1)))

  @doc """
  TThis function receives a list of lists and validates that for the
  elements of each one the distance is >= 1 and <= 3, to meet the
  second condition:

  - Any two adjacent levels differ by at least one and at most three.

  ## Examples

      iex> get_valid_adjacent_levels([[1, 3, 6, 7, 9], [8, 6, 4, 4, 1]])
      iex> [[1, 3, 6, 7, 9]]
  """
  @spec get_valid_adjacent_levels([list()]) :: [list()]
  def get_valid_adjacent_levels(levels),
    do: Enum.filter(levels, &valid_levels_distance?(&1, false))

  @doc """
  Receives a path corresponding to a .txt file with the exercise input,
  reads it and applies the necessary transformations.
  """
  @spec get_input(String.t()) :: list()
  def get_input(path) do
    path
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&convert_string_to_int_list(&1))
  end

  # Converts the string "1, 2, 3, 4" to [1, 2, 3, 4]
  defp convert_string_to_int_list(string) do
    string
    |> String.split(" ")
    |> Enum.map(&String.to_integer(&1))
  end

  defp is_ascending?(list), do: Enum.sort(list) == list
  defp is_descending?(list), do: Enum.sort(list, :desc) == list

  defp valid_levels_distance?(level, is_valid?) when length(level) == 1, do: is_valid?

  defp valid_levels_distance?([head | rest] = _level, _is_valid?) do
    distance = abs(head - List.first(rest))

    if distance >= 1 && distance <= 3 do
      valid_levels_distance?(rest, true)
    else
      false
    end
  end

  # This is a wrapper for the previous functions that validate whether
  # a list is ordered and the distance between its levels is allowed.
  defp is_a_valid_list?(list),
    do: (is_ascending?(list) || is_descending?(list)) && valid_levels_distance?(list, false)
end
