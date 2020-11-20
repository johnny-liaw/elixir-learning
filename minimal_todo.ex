defmodule MinimalTodo do
  def start do
    load_csv()
  end

  def load_csv() do
    filename = IO.gets("Name of csv to load") |> String.trim
    read(filename)
      |> parse
      |> get_command
  end

  def get_command(data) do
    prompt = """
    R)ead todos     A)dd a todo    D)elete a todo      Q)uit app     S)ave csv
    """
    command = IO.gets(prompt)
      |> String.trim
      |> String.downcase

    case command do
      "r" -> show_todos(data)
      "d" -> delete_todos(data)
      "a" -> add_todo(data)
      "s" -> save_csv(data)
      "q" -> "Goodbye!"
      _ -> get_command(data)
    end
  end

  def prepare_csv(data) do
    headers = ["Item", get_fields(data)]
    items = Map.keys(data)
    item_rows = Enum.map(items, fn item ->
      [item | Map.values(data[item])]
    end)
    all_rows = [headers | item_rows]
    row_strings = Enum.map(all_rows, &(Enum.join(&1, ",")))
    Enum.join(row_strings, "\n")
  end

  def save_csv(data) do
    csv_name = IO.gets("New CSV name: ") |> String.trim
    data_body = prepare_csv(data)
    case File.write(csv_name, data_body) do
      :ok -> IO.puts("CSV #{csv_name} saved\n")
      {:error, reason} -> IO.puts("Could not save file\n")
                          IO.puts("#{:file.format_error reason}\n")
    end
  end

  def add_todo(data) do
    item_name = get_item_name(data)
    field_data_map = Enum.map(
      get_fields(data),
      fn field_name -> get_data_given_field(field_name) end)
      |> Enum.into(%{})
    new_data = Map.merge(data, %{item_name => field_data_map})
    get_command(new_data)
  end

  def get_data_given_field(field_name) do
    field_data = IO.gets("Enter for #{field_name}: ") |> String.trim
    case field_name do
      _ -> {field_name, field_data}
    end
  end

  def get_fields(data) do
    data[hd Map.keys(data)] |> Map.keys
  end

  def get_item_name(data) do
    item_name = IO.gets("Enter new todo name: ") |> String.trim
    if Map.has_key?(data, item_name) do
      IO.puts("Todo #{item_name} already exists\n")
      get_item_name(data)
    else
      item_name
    end
  end

  def delete_todos(data) do
    todo_to_delete = IO.gets("Which todo do you want to delete? ")
      |> String.trim
    if Map.has_key?(data, todo_to_delete) do
      Map.delete(data, todo_to_delete) |> get_command
    else
      IO.puts("Key #{todo_to_delete} not found, please try again\n")
      delete_todos(data)
    end
  end

  def read(filename) do
    case File.read(filename) do
      {:ok, body} -> body
      {:error, reason} ->
        IO.puts "Could not open file #{filename}\n"
        IO.puts "Reason: #{:file.format_error reason}\n"
        start()
    end
  end

  def parse(body) do
    [header | items] = String.split(body, ~r{(\r\n|\r|\n)})
    titles = tl String.split(header, ",")
    parse_lines(items, titles)
  end

  def parse_lines(lines, titles) do
    Enum.reduce(lines, %{}, fn line, built ->
      [name | fields] = String.split(line, ",")
      if Enum.count(fields) == Enum.count(titles) do
        line_data = Enum.zip(titles, fields) |> Enum.into(%{})
        Map.merge(built, %{name => line_data})
      else
        built
      end
    end)
  end

  def show_todos(data, next_command? \\ true) do
    items = Map.keys(data)
    IO.puts("You have the following todos: \n")
    Enum.each(items, fn item -> IO.puts(item) end)
    IO.puts("\n")

    if next_command? do
      get_command(data)
    end
  end
end
