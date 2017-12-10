defmodule Experimental do
  def calculate_steps(num) do
    create_spiral(num)
  end

  def create_spiral(num) do
    %{{0,0} => 1}
             |> round(2,0,1,0,:up,num,1)
             |> IO.inspect
  end

  def round(_, _, _, _, _, _, num, sum) when sum > num do
    sum 
  end 
  def round(map, times, counter, posx, posy, :up, num, sum) when times <= counter do
    round(map, times, 0, posx-1, posy-1, :left, num, sum)
  end
  def round(map, times, counter, posx, posy, :up, num, _sum) do
    sum = get_sum(map,posx, posy)
    round(Map.put(map, {posx, posy}, sum), times, counter+1, posx, posy+1, :up, num, sum)
  end

  def round(map, times, counter, posx, posy, :left, num, sum) when times <= counter do
    round(map, times, 0, posx+1, posy-1, :down, num, sum)
  end
  def round(map, times, counter, posx, posy, :left, num, _sum) do
    sum = get_sum(map,posx, posy)
    round(Map.put(map, {posx, posy}, sum), times, counter+1, posx-1, posy, :left, num, sum)
  end

  def round(map, times, counter, posx, posy, :down, num, sum) when times <= counter do
    round(map, times, 0, posx+1, posy+1, :right, num, sum)
  end
  def round(map, times, counter, posx, posy, :down, num, _sum) do
    sum = get_sum(map,posx, posy)
    round(Map.put(map, {posx, posy}, sum), times, counter+1, posx, posy-1, :down, num, sum)
  end

  def round(map, times, counter, posx, posy, :right, num, sum) when times <= counter do
    round(map, times+2, 0, posx, posy, :up, num, sum)
  end
  def round(map, times, counter, posx, posy, :right, num, _sum) do
    sum = get_sum(map,posx, posy)
    round(Map.put(map, {posx, posy}, sum), times, counter+1, posx+1, posy, :right, num, sum)
  end

  def get_sum(map,posx,posy) do
    ( map[{posx-1,posy+1}]  || 0 )+
    ( map[{posx,posy+1}]    || 0 )+
    ( map[{posx+1,posy+1}]  || 0 )+
    ( map[{posx-1,posy}]    || 0 )+
    ( map[{posx+1,posy}]    || 0 )+
    ( map[{posx-1,posy-1}]  || 0 )+
    ( map[{posx,posy-1}]    || 0 )+
    ( map[{posx+1,posy-1}]  || 0 )
  end

end

Experimental.calculate_steps(String.to_integer(List.last(System.argv)))

#elixir experimental2.exs 325489
