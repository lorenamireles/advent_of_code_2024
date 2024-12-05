defmodule AdventOfCode2024.Day4 do
  @moduledoc """
  Advent of Code 2024: Day 4 -  Ceres Search

  https://adventofcode.com/2024/day/4
  """

  @doc """
  Function to execute the first part of the exercise.

  ## Examples

      iex> AdventOfCode2024.Day4.part_1()
      iex> 18

  Update the path with the location of your input file.
  """
  @spec part_1() :: integer()
  def part_1 do
    path = "/your_path/your_input.txt"

    input = get_input(path)
    word = String.graphemes("XMAS")

    initial_coordinates = get_char_positions(input, "X")
    count_string_occurrences(word, initial_coordinates, input)
  end

  @doc """
  Function to execute the first part of the exercise.

  ## Examples

      iex> AdventOfCode2024.Day4.part_2()
      iex> 9

  Update the path with the location of your input file.
  """
  @spec part_2() :: integer()
  def part_2 do
    path = "/your_path/your_input.txt"
    input = get_input(path)

    initial_coordinates = get_char_positions(input, "A")
    count_x_mas(initial_coordinates, input)
  end

  @doc """
  This function counts how many times the X-MAS pattern appears.
  """
  @spec count_x_mas(list(), map) :: integer()
  def count_x_mas(coordinates, input) do
    Enum.reduce(coordinates, 0, fn {coordinate, _elem}, acc ->
      valid_x_mas(coordinate, input) + acc
    end)
  end

  @doc """
  This function receives a coordinate that corresponds to a letter A
  and checks its adjacent coordinates. If it meets the X-MAS condition,
  it returns 1; otherwise, it returns 0.
  """
  @spec valid_x_mas(tuple, map) :: integer()
  def valid_x_mas({row, colum} = _coordinate, input) do
    top_left = input[{row - 1, colum - 1}]
    top_right = input[{row - 1, colum + 1}]
    bottom_left = input[{row + 1, colum - 1}]
    bottom_right = input[{row + 1, colum + 1}]

    cond do
      top_left == "M" && bottom_left == "M" && top_right == "S" && bottom_right == "S" -> 1
      top_left == "M" && bottom_left == "S" && top_right == "M" && bottom_right == "S" -> 1
      top_left == "S" && bottom_left == "S" && top_right == "M" && bottom_right == "M" -> 1
      top_left == "S" && bottom_left == "M" && top_right == "S" && bottom_right == "M" -> 1
      true -> 0
    end
  end

  @doc """
  This function takes a word, a list of coordinates, and an
  input. Returns how many times the word appears in the input.
  """
  @spec count_string_occurrences([String.t()], [list], map()) :: integer()
  def count_string_occurrences(word, coordinates, input) do
    Enum.reduce(coordinates, 0, fn {coord, _elem}, occurrences ->
      check_coordinate(coord, word, input) + occurrences
    end)
  end

  @doc """
  Each coordinate has 8 options to be checked, horizontal,
  vertical and diagonal. This function defines those
  positions and counts the adjacent words.
  """
  @spec check_coordinate(tuple, [String.t()], map) :: integer
  def check_coordinate({row, colum}, word, input) do
    positions_to_check = [
      %{value: {row, colum + 1}, row: 0, colum: 1},
      %{value: {row, colum - 1}, row: 0, colum: -1},
      %{value: {row + 1, colum}, row: 1, colum: 0},
      %{value: {row - 1, colum}, row: -1, colum: 0},
      %{value: {row - 1, colum + 1}, row: -1, colum: 1},
      %{value: {row - 1, colum - 1}, row: -1, colum: -1},
      %{value: {row + 1, colum + 1}, row: 1, colum: 1},
      %{value: {row + 1, colum - 1}, row: 1, colum: -1}
    ]

    Enum.reduce(positions_to_check, 0, fn position, acc ->
      match_word(word, position, input) + acc
    end)
  end

  @doc """
  This function receives a coordinate and validates whether
  it can form a word from it, checking the positions adjacent to it.
  """
  @spec match_word([String.t()], map, map) :: integer()
  def match_word(
        [_head | rest] = _word,
        %{value: {row, colum}, row: row_inc, colum: colum_inc},
        input
      ) do
    elem = List.first(rest)

    cond do
      rest == [] ->
        1

      input[{row, colum}] == elem ->
        match_word(
          rest,
          %{value: {row + row_inc, colum + colum_inc}, row: row_inc, colum: colum_inc},
          input
        )

      true ->
        0
    end
  end

  @doc """
  This function takes a character and a list of elements in
  the format {coordinate, character} and returns all elements
  that match.
  """
  @spec get_char_positions(map(), String.t()) :: [list()]
  def get_char_positions(input, character),
    do: Enum.filter(input, fn {_coordinate, value} -> value == character end)

  @doc """
  Receives a path corresponding to a .txt file with the exercise input,
  reads it and applies the necessary transformations.
  """
  @spec get_input(String.t()) :: list()
  def get_input(path) do
    path
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.with_index(fn element, index -> get_coordinate_format({element, index}) end)
    |> List.flatten()
    |> Enum.into(%{})
  end

  #  This function takes a tuple with a string and an index and converts it to a map with a coordinate format
  defp get_coordinate_format({word_row, row_index}) do
    word_row
    |> String.graphemes()
    |> Enum.with_index(fn char, colum_index -> {{row_index, colum_index}, char} end)
  end
end
