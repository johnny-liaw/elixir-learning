filename = IO.gets("File name to count the words from: ") |> String.trim
File.read!(filename) |> String.split |> IO.inspects
