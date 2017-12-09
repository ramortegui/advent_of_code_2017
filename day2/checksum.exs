defmodule Checksum do
  def open_file(file) do
    {:ok, file_sistem} = File.open(file)
    file_sistem
  end
  
  def calculate_checksum(file) do
    calculate_line_checksum(0, file, IO.read(file, :line)) 
  end

  def calculate_line_checksum(accum, _ , :eof ) do
    accum
  end

  def calculate_line_checksum(accum, file, line) do
    checksum_line = line 
                    |> String.trim
                    |> String.split
                    |> Enum.map(fn(x)-> String.to_integer(x) end)
                    |> calculate_max_min()
    calculate_line_checksum(accum+checksum_line, file, IO.read(file, :line)) 
  end

  defp calculate_max_min(list) do
    Enum.max(list)-Enum.min(list)
  end

  def calculate_div_checksum(file) do
    calculate_div_line_checksum(0, file, IO.read(file, :line))
  end

  def calculate_div_line_checksum(accum, _ , :eof ), do: accum

  def calculate_div_line_checksum(accum, file, line) do
    checksum_line = line
                    |> String.trim
                    |> String.split
                    |> Enum.map(fn(x) -> String.to_integer(x) end)
                    |> calculate_line_div
    calculate_div_line_checksum(accum+checksum_line, file, IO.read(file, :line))
  end

  def calculate_line_div([head|tail]) do
    case Enum.filter(tail,fn(x)-> check_div(head,x) end) do
      [] -> calculate_line_div(tail)
      [winner|_]-> return_div(head,winner) 
    end
  end

  def return_div(head,winner) when rem(head,winner) == 0, do: div(head,winner)
  def return_div(head,winner), do: div(winner,head)

  def check_div(num1, num2) when rem(num1,num2) == 0, do: true

  def check_div(num1, num2) when rem(num2,num1) == 0, do: true
  def check_div(_,_), do: false 

end


Checksum.open_file("input_a.txt")
|> Checksum.calculate_checksum
|> IO.puts


Checksum.open_file("input_a.txt")
|> Checksum.calculate_div_checksum
|> IO.puts

