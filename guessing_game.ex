defmodule GuessingGame do

  def start_game() do
    get_name()
  end

  def get_name() do
    response = IO.gets("What's your name?")
    trimmed_resp = String.trim(response)
    case trimmed_resp do
      "Johnny" -> special_response(trimmed_resp)
      _ -> generic_response(trimmed_resp)
    end
  end

  def special_response(response) do
    IO.puts("Wow, Johnny is in the house!! \n")
    get_name()
  end

  def generic_response(response) do
    IO.puts("Wow, I don't know #{response} but it's good to have you here! \n")
    get_name()
  end
end
