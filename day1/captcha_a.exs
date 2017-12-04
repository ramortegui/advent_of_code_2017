defmodule Captcha do
  def accumulate([head|[head|third]],acum) do
    accumulate([head|third],acum+parse(head))
  end
  def accumulate([_head | tail],acum) do
    accumulate(tail,acum)
  end 
  def accumulate([],acum) do
    acum
  end
  def calculate(list = [head|_tail]) do
    acum = if List.last(list) == head, do: parse(head), else: 0
    list
    |> accumulate(acum)
  end
  def parse(val) do
    {num ,_other} = Integer.parse(val)
    num
  end

  def calculate_2(list) do
    Enum.reduce(list,0,fn
                  {val1,val1},acc -> acc+2*parse(val1)
                  {_,_},acc -> acc 
    end)
  end
  def calculate_half(list) do
    {list1, list2} = Enum.split(list,round(Enum.count(list)/2))
    Enum.zip(list1, list2)
    |> calculate_2
  end
end

{:ok, content} = File.read('input_p1.txt')

IO.inspect Captcha.calculate(String.codepoints(String.trim(content)))
IO.inspect Captcha.calculate_half(String.codepoints(String.trim(content)))

#IO.inspect Captcha.calculate(String.codepoints("1111"))
#IO.inspect Captcha.calculate(String.codepoints("1234"))
#IO.inspect Captcha.calculate(String.codepoints("1122"))
#IO.inspect Captcha.calculate(String.codepoints("91212129"))
