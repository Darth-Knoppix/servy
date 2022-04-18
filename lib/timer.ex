defmodule Timer do
  def remind(msg, time) when is_integer(time) do
    spawn(Timer, :loop, [msg, time])
  end

  def loop(msg, time) do
    :timer.sleep(time * 1000)
    IO.puts(msg)
  end
end

Timer.remind("Stand Up", 5)
Timer.remind("Sit Down", 10)
Timer.remind("Fight, Fight, Fight", 15)
