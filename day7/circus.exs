defmodule Circus do
  def process_file(filename) when is_binary(filename) do
    {:ok , file} = File.open(filename)
    process_file(%{}, IO.read(file,:line), file)
    |> check_no_parent 
  end

  def check_no_parent(list) do
    Enum.filter(Map.keys(list),fn(x)-> list[x][:parent] == "" end)
                                                         |> IO.inspect
  end

  def process_file(structure, :eof, _ ), do: structure

  def process_file(structure, line, file) do
    structure = line
                |> String.trim
                |> String.split("->")
                |> update_structure(structure)
    process_file(structure, IO.read(file, :line), file)
  end

  def update_structure(list, structure) do
    process = Enum.at(list, 0) |> String.split 
    val = String.slice(Enum.at(process,1),1..-2)
    cond do
      is_nil(structure[Enum.at(process,0)]) -> update_structure(list, Map.put(structure, Enum.at(process,0), %{ parent: "", val: String.to_integer(val)}))
      true -> add_sons(structure, Enum.at(process,0),  Enum.at(list,1))
    end
  end

  def add_sons(structure, _parent, sons) when is_nil(sons), do: structure
  def add_sons(structure, parent, sons) do
    sons 
    |> String.trim
    |> String.split(",")
    |> add_son(structure, parent)
  end

  def add_son([], structure, _), do: structure
  def add_son([head|tail], structure, parent) do
    cond do
      is_nil(structure[head]) -> 
        structure = Map.put(structure, String.trim(head), %{ parent: parent}) 
        add_son(tail, structure, parent)
      true -> 
        structure = Map.put(structure, String.trim(head), %{ parent: parent })
        add_son(tail, structure, parent)
    end
  end
  def new_structure(list) do
    Enum.at(list, 0)
    |> String.split 
  end
end


Circus.process_file("input.txt")
