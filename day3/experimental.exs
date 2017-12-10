defmodule Experimental do
  def calculate_steps(num) do
    calculate_steps(1,0,num)
  end
  
  def calculate_steps(ring,long,num) when round(ring*ring) < num do
    calculate_steps(ring+2,long+1, num)
  end
  
  def calculate_steps(ring,long,num) when ((ring*ring)-(ring-1)) <= num do
    min = (ring*ring)-(ring-1)
    long+abs(((min+(ring*ring))/2)-num)
  end

  def calculate_steps(ring,long,num) when (ring*ring)-((ring-1)*2) <= num do
    min = (ring*ring)-((ring-1)*2)
    long+abs(((min+(min+ring-1))/2)-num)
  end

  def calculate_steps(ring,long,num) when (ring*ring)-((ring-1)*3) <= num do
    min = (ring*ring)-((ring-1)*3)
    long+abs(((min+(min+ring-1))/2)-num)
  end

  def calculate_steps(ring,long,num) do
    min = (ring*ring)-((ring-1)*4)
    long+abs(((min+(min+ring-1))/2)-num)
  end
end

Experimental.calculate_steps(String.to_integer(List.last(System.argv)))
|> IO.puts


#$>elixir experimental.exs 325489
