defmodule TallerElixir do
  use Application

  def start(_type, _args) do
    IO.puts("""
    ¿Qué sistema desea usar?
    1. Gimnasio
    2. Inventario
    """)

    case IO.gets("Opción: ") |> String.trim() do
      "1" -> Gimnasio.Menu.iniciar()
      "2" -> Inventario.Menu.iniciar()
      _   -> IO.puts("Opción inválida")
    end

    Supervisor.start_link([], strategy: :one_for_one)
  end
end
