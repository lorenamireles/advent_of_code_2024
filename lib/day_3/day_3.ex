defmodule AdventOfCode2024.Day3 do
  @moduledoc """
  Advent of Code 2024: Day 3 -  Mull It Over

  https://adventofcode.com/2024/day/3
  """

  @doc """
  Function to execute the first part of the exercise.

  ## Examples

      iex> AdventOfCode2024.Day3.part_1()
      iex> 161

  Update the path with the location of your input file.
  """
  @spec part_1() :: integer()
  def part_1 do
    path = "/your_path/your_input.txt"

    path
    |> get_input()
    |> get_valid_mul_instructions()
    |> sum_multiplication_results()
  end

  @doc """
  Function to execute the first part of the exercise.

  ## Examples

      iex> AdventOfCode2024.Day3.part_2()
      iex> 48

  Update the path with the location of your input file.
  """
  @spec part_2() :: integer()
  def part_2 do
    path = "/your_path/your_input.txt"

    path
    |> get_input()
    |> remove_invalid_blocks()
    |> get_valid_mul_instructions()
    |> sum_multiplication_results()
  end

  @doc """
  Receives a path corresponding to a .txt file with the exercise input,
  reads it and applies the necessary transformations.
  """
  @spec get_input(String.t()) :: [String.t()]
  def get_input(path), do: File.read!(path)

  @doc """
  Receives a string representing the input and uses a regular expression to
  filter all values ​​that match the pattern mul(number, number).
  """
  @spec get_valid_mul_instructions(String.t()) :: String.t()
  def get_valid_mul_instructions(section) do
    regex_valid_multi = ~r/mul\((\d+),(\d+)\)/
    Regex.scan(regex_valid_multi, section, capture: :all_but_first)
  end

  @doc """
  Receives a list of all valid mul instructions, which have a format
  (x,y) and returns the sum of their multiplications.
  """
  @spec sum_multiplication_results([list()]) :: integer()
  def sum_multiplication_results(correct_instructions) do
    Enum.reduce(correct_instructions, 0, fn [x, y] = _mul, acc ->
      String.to_integer(x) * String.to_integer(y) + acc
    end)
  end

  @doc """
  This function receives the string to be analyzed and separates it each
  time it finds a don't or do, then iterates over the elements and adds
  or discards them according to the conditions:

  - The do() instruction enables future mul instructions.
  - The don't() instruction disables future mul instructions.
  """
  @spec remove_invalid_blocks(String.t()) :: String.t()
  def remove_invalid_blocks(section) do
    regex = ~r/(don't[(][)]|do[(][)])/

    section
    |> String.split(regex, include_captures: true)
    |> remove_invalid_blocks_per_instruction([])
  end

  defp remove_invalid_blocks_per_instruction([], acc) do
    Enum.reduce(acc, "", fn elem, new_acc -> elem <> new_acc end)
  end

  defp remove_invalid_blocks_per_instruction(["don't()" = head | rest] = _instruction, acc) do
    if rest != [] && List.first(rest) != "do()" do
      remove_invalid_blocks_per_instruction([head | List.delete_at(rest, 0)], acc)
    else
      remove_invalid_blocks_per_instruction(rest, acc)
    end
  end

  defp remove_invalid_blocks_per_instruction(["do()" | rest] = _instruction, acc) do
    if rest != [] && List.first(rest) != "don't()" do
      new_acc = [List.first(rest) | acc]
      remove_invalid_blocks_per_instruction(List.delete_at(rest, 0), new_acc)
    else
      remove_invalid_blocks_per_instruction(rest, acc)
    end
  end

  defp remove_invalid_blocks_per_instruction([head | rest] = _instruction, acc) do
    remove_invalid_blocks_per_instruction(rest, [head | acc])
  end
end
