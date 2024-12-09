defmodule AdventOfCode2024.Day7 do
  @moduledoc """
  Advent of Code 2024: Day 7 - Bridge Repair

  https://adventofcode.com/2024/day/7
  """

  @doc """
  Function to execute the first part of the exercise.

  ## Examples

      iex> AdventOfCode2024.Day7.part_1()
      iex> 3749

  Update the path with the location of your input file.
  """
  @spec part_1() :: integer()
  def part_1 do
    path = "/your_path/your_input.txt"

    path
    |> get_input()
    |> get_possible_equations(["+", "*"])
    |> sum_value_possible_equations()
  end

  @doc """
  Function to execute the first part of the exercise.

  ## Examples

      iex> AdventOfCode2024.Day7.part_2()
      iex> 11387

  Update the path with the location of your input file.
  """
  @spec part_2() :: integer()
  def part_2 do
    path = "/your_path/your_input.txt"

    path
    |> get_input()
    |> get_possible_equations(["+", "*", "||"])
    |> sum_value_possible_equations()
  end

  @spec sum_value_possible_equations(list) :: integer()
  def sum_value_possible_equations(valid_equations) do
    Enum.reduce(valid_equations, 0, fn equation, acc ->
      task = Task.await(equation)
      if !is_nil(task), do: task + acc, else: acc
    end)
  end

  @doc """
  This function filters out all lists that are valid equations.
  """
  @spec get_possible_equations(list(), list()) :: list()
  def get_possible_equations(numbers, operators),
    do:
      Enum.map(numbers, fn {value, number} ->
        Task.async(fn -> is_a_valid_equation(value, number, operators) end)
      end)

  @doc """
  This function takes a value and a list and checks if after
    adjusting the operators, that value is equal to the one sought..
  """
  @spec is_a_valid_equation(integer(), [integer], list) :: integer
  def is_a_valid_equation(value, number, operators) do
    number
    |> apply_operations(0, operators)
    |> List.flatten()
    |> Enum.find(&(&1 == value))
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
    |> Enum.reduce([], fn equation, acc -> get_equation_format(equation, acc) end)
  end

  # This function takes a string with the format "190: 10 19" and returns {190, [10, 19]}
  defp get_equation_format(equation, acc) do
    [value, numbers] = String.split(equation, ": ")
    value = String.to_integer(value)
    numbers = String.split(numbers, " ") |> Enum.map(&String.to_integer(&1))

    [{value, numbers} | acc]
  end

  defp apply_operations([head], acc, operators) do
    Enum.map(operators, fn operator ->
      case operator do
        "+" ->
          head + acc

        "*" ->
          head * acc

        "||" ->
          head_concat = "#{acc}#{head}"
          String.to_integer(head_concat)
      end
    end)
  end

  defp apply_operations([head | rest] = _number, acc, operators) do
    Enum.map(operators, fn operator ->
      case operator do
        "+" ->
          apply_operations(rest, head + acc, operators)

        "*" ->
          acc = if acc == 0, do: 1, else: acc
          apply_operations(rest, head * acc, operators)

        "||" ->
          head_concat = String.to_integer("#{acc}#{head}")
          apply_operations(rest, head_concat, operators)
      end
    end)
  end
end
