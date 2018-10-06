defmodule FibonacciScheduler do
  def run(processes_amount, module, func, calculation) do
    1..processes_amount
    |> Enum.map(fn _ -> spawn(module, func, [self()]) end)
    |> schedule_processes(calculation, [])
  end

  defp schedule_processes(processes, queue, results) do
    receive do
      {:ready, pid} when length(queue) > 0 ->
        [head | tail] = queue
        send(pid, {:fib, head, self()})
        schedule_processes(processes, tail, results)

      {:ready, pid} ->
        send(pid, {:shutdown})

        if length(processes) > 1 do
          schedule_processes(List.delete(processes, pid), queue, results)
        else
          Enum.sort(results, fn {n1, _}, {n2, _} -> n1 <= n2 end)
        end

      {:answer, number, result, _pid} ->
        schedule_processes(processes, queue, [{number, result} | results])
    end
  end
end
