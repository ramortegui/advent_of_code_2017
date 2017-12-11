defmodule Circus do
  def process_file(filename) when is_binary(filename) do
    {:ok , file} = File.open(filename)
    structure = process_file(%{}, IO.read(file,:line), file)
    root = root(structure)
           |> IO.inspect 
    
    sum_weights(structure, root)
  end


  def sum_weights(structure, root) when is_atom(root) do
    to_update = Enum.filter(Map.keys(structure),fn(x)-> structure[x][:parent] == root end)
    weights(structure, to_update)
  end

  def weights(structure, []), do: structure 

  def weights(structure, [head|tail]) do
    to_update = Enum.filter(Map.keys(structure),fn(x)-> structure[x][:parent] == head end)
    structure = weights(structure, to_update)
    sum = Enum.map(to_update,fn(x)-> (structure[x][:sum_tree]||0) end)
    list = Enum.uniq(sum)
    if( Enum.count(list) > 1) do
      Enum.each(to_update,fn(x)-> IO.inspect structure[x] end)
    end
    put_in(structure,[head,:sum_tree],structure[head][:val]+Enum.sum(sum))
    |> weights(tail)
  end

  def root(list) do
    List.first(Enum.filter(Map.keys(list),fn(x)-> list[x][:parent] == "" end))
  end

  def process_file(structure, :eof, _ ), do: structure

  def process_file(structure, line, file) do
    line
    |> String.trim
    |> String.split("->")
    |> update_structure(structure)
    |> process_file( IO.read(file, :line), file)
  end

  def update_structure(list, structure) do
    process = Enum.at(list, 0) |> String.split 
    val = String.slice(Enum.at(process,1),1..-2)|> String.to_integer
    cond do
      is_nil(structure[String.to_atom(Enum.at(process,0))]) -> 
      update_structure(list, Map.put(structure, String.to_atom(Enum.at(process,0)), %{ parent: "", val: val}))
      true -> 
       put_in(structure, [String.to_atom(Enum.at(process,0)), :val], val)
       |> add_as_parent(String.to_atom(Enum.at(process,0)),  Enum.at(list,1))
    end
  end

  def add_as_parent(structure, _parent, sons) when is_nil(sons), do: structure
  def add_as_parent(structure, parent, sons) do
    sons 
    |> String.trim
    |> String.split(",")
    |> add_parent(structure, parent)
  end

  def add_parent([], structure, _), do: structure
  def add_parent([head|tail], structure, parent) do
    cond do
      is_nil(structure[String.to_atom(String.trim(head))]) ->
        add_parent(tail, Map.put(structure, String.trim(head)|>String.to_atom, %{ parent: parent, val: -1}), parent)
      true -> 
      add_parent(tail, put_in(structure, [String.trim(head)|>String.to_atom, :parent], parent ), parent)
    end
  end
end

Circus.process_file("input.txt")
#Circus.process_file("input_test.txt")
