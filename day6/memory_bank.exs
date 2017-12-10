defmodule MemoryBank do
  def solve(list, history, steps) do
    history = Map.put(history, list, steps)
    new_list = list
               |> relocate
    steps = steps+1
    case(history[new_list]) do
      x when is_nil(x) -> solve(new_list, Map.put(history, new_list, steps), steps)
      x when x > 0  -> IO.puts "Cicle #{steps-history[new_list]}"; steps
    end
  end

  def relocate(list) do
    max = Enum.max(list)
    column = Enum.find_index(list,&(&1 == max))
    List.replace_at(list,column,0)
    |> redistribute(Enum.count(list), max, column+1)
  end

  def redistribute(list, size, quantity, index) when index < size and quantity > 0 do
    list = List.replace_at(list, index, Enum.at(list, index)+1) 
    redistribute(list, size, quantity-1, index+1)
  end 
  
  def redistribute(list, size, quantity, _) when quantity > 0 do
    list = List.replace_at(list, 0, Enum.at(list, 0)+1) 
    redistribute(list, size, quantity-1, 1)
  end 

  def redistribute(list, _, _, _), do: list
end


IO.puts MemoryBank.solve([5,1,10,0,1,7,13,14,3,12,8,10,7,12,0,6],%{},0)
#IO.inspect MemoryBank.solve([0,2,7,0],%{},0)
