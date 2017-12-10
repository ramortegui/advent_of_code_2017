defmodule PassPhrase do
  def check_file(filename) do
    {:ok, file} = File.open(filename)
    file
    |> valid_passphrase(IO.read(file, :line), 0)
    |> IO.puts
  end

  def valid_passphrase(_,:eof,valids), do: valids
  def valid_passphrase(file,line,valids) do
    valid = line
            |> String.trim
            |> String.split(" ")
            |> validity 
    valid_passphrase(file, IO.read(file, :line), valids+valid)
  end

  def validity([]), do: 1 
  def validity([head|tail]) do
    repeated = Enum.reduce(tail,0,fn(x,acc)-> check(head,x)+acc end)
    case repeated do
      repeated when repeated > 0 -> 0  
      _ -> validity(tail)  
    end
  end

  def check(string1, string2) do
    case string1 == string2 || anagram(string1, string2) do
      true -> 1
      _    -> 0
    end
  end

  def anagram(string1, string2) do
    Enum.sort(String.to_charlist(string1)) == Enum.sort(String.to_charlist(string2))
  end
end


PassPhrase.check_file('input.txt')
