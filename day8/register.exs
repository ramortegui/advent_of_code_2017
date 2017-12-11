defmodule Register do
  def process_file(filename) do
    {:ok, file} = File.open(filename)
    run_procedure(%{ maximum: 0 }, IO.read(file, :line), file)
    |> print_max
    |> print_max_mem
  end

  def print_max_mem(reg) do
    IO.puts "max memory"
    IO.puts reg[:maximum]
    reg
  end
  def print_max(reg) do
    IO.puts "max"
    Map.keys(Map.delete(reg,:maximum))
    |> Enum.map(&(reg[&1]))
    |> Enum.max
    |> IO.puts
    reg
  end
  def run_procedure(reg, :eof, _file), do: reg
  
  def run_procedure(reg, line, file) do
    [var, inc_dec , qty, _, var_req, op, req] = line
              |> String.trim
              |> String.split
              |> Enum.map(&(String.trim(&1)))

    reg = reg
          |> update_var(var)  
          |> update_var(var_req)

    var_req = reg[var_req]

    [var, inc_dec, String.to_integer(qty), var_req, op, String.to_integer(req)] 
    |> process_instruction(reg)
    |> run_procedure(IO.read(file, :line), file)
  end

  def update_var(reg,var) do
    case reg[var] do
      nil -> put_in(reg, [var], 0)
      _ -> reg
    end
  end
  def process_instruction([var, inc_dec , qty, var_req, "==", req], reg) when var_req == req do
    do_adjustment(reg, var, qty, inc_dec)
  end
  def process_instruction([var, inc_dec , qty, var_req, "<", req], reg) when var_req < req do
    do_adjustment(reg, var, qty, inc_dec)
  end
  def process_instruction([var, inc_dec , qty, var_req, "<=", req], reg) when var_req <= req do
    do_adjustment(reg, var, qty, inc_dec)
  end
  def process_instruction([var, inc_dec , qty, var_req, ">", req], reg) when var_req > req do
    do_adjustment(reg, var, qty, inc_dec)
  end
  def process_instruction([var, inc_dec , qty, var_req, ">=", req], reg) when var_req >= req do
    do_adjustment(reg, var, qty, inc_dec)
  end
  def process_instruction([var, inc_dec , qty, var_req, "!=", req], reg) when var_req != req do
    do_adjustment(reg, var, qty, inc_dec)
  end
  def process_instruction([_, _, _, _, op, _], reg) when op == "==" or op == "<=" or op == "<" or op == ">=" or op == ">" or op == "!=", do: reg

  def do_adjustment(reg, var, qty, "inc") do
    reg 
    |> check_max_mem(reg[:maximum], reg[var]+qty )
    |> put_in([var], reg[var]+qty)
  end

  def do_adjustment(reg, var, qty, "dec")do
    put_in(reg, [var], reg[var]-qty)
  end

  def check_max_mem(reg, max, new_max ) when max < new_max, do: put_in(reg, [:maximum], new_max)
  def check_max_mem(reg, _, _), do: reg


end


Register.process_file("input.txt")
#Register.process_file("input_test.txt")
