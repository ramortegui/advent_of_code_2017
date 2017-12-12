defmodule Processor do
  def process_file(file) do
    {:ok, content} = File.read(file)
    content
    |> String.trim
    |> String.codepoints
    |> process(false,0,0,0)
    |> IO.inspect
  end

  def process(["!"|tail], true, group, score, garbage) do
    [_thead|ttail] =  tail
    process(ttail, true, group, score, garbage)
  end
  
  def process([">"|tail], true, group, score, garbage) do
    process(tail, false, group, score, garbage)
  end
  
  def process([_head|tail], true, group, score, garbage) do
    process(tail, true, group, score, garbage+1)
  end

  def process(["<"|tail], false, group, score, garbage)do
    process(tail, true, group, score, garbage)
  end

  def process(["}"|tail], false, group, score, garbage) do
    score = score - 1
    process(tail, false, group, score, garbage)
  end

  def process(["{"|tail], false, group, score, garbage) do
    score = score + 1
    group = group + score 
    process(tail, false, group, score, garbage)
  end

  def process([], _, group, score, garbage) do
    %{group: group, score: score, garbage: garbage}
  end
  
  def process([","|tail], false, group, score, garbage) do
    process(tail, false, group, score, garbage)
  end

end

Processor.process_file("input.txt")
