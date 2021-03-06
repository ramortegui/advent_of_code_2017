defmodule Maze do
  def solve_maze(filename) when is_binary(filename) do
    {:ok, content} = File.read(filename)
    content
    |> String.trim
    |> String.split
    |> Enum.map(&(String.to_integer(&1)))
    |> solve_maze
    |> IO.puts
  end

  def solve_maze(list) do
    solve_maze(list, 0, Enum.at(list,0), Enum.count(list), 0)
  end

  def solve_maze(list, actual_index, next_index, size, acc) when size > 0 and next_index < size do
    val = Enum.at(list,actual_index)
    move = check_offset(val) 
    solve_maze(List.update_at(list,actual_index,&(&1=val+move)),actual_index+val, Enum.at(list,actual_index+val),size,acc+1)
  end

  def solve_maze(_,_,_,_,acc), do: acc

  def check_offset(val) when val >= 3, do: -1
  def check_offset(_), do: 1
end


Maze.solve_maze("input.txt")
