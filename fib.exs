defmodule Fib do
  to_process = List.duplicate(37, 20)

  Enum.each(1..10, fn processes_amount ->
    {time, result} =
      :timer.tc(FibonacciScheduler, :run, [processes_amount, FibonacciCalc, :fib, to_process])

    if processes_amount == 1 do
      IO.puts(inspect(result))
      IO.puts("\n #     time (s)")
    end

    :io.format("~2B     ~.2f~n", [processes_amount, time / 1_000_000.0])
  end)
end
