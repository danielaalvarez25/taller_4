defmodule Menu do
  alias Inventario
  alias Producto
  alias ArchivoJSON

  def iniciar() do
    inventario = ArchivoJSON.cargar()
    loop(inventario)
  end

  defp loop(inv) do
    IO.puts("""
    ===== MENÚ INVENTARIO =====
    1. Agregar producto
    2. Actualizar producto
    3. Eliminar producto
    4. Listar productos
    5. Reportes
    0. Salir
    ============================
    """)

    opcion = IO.gets("Seleccione opción: ") |> String.trim()

    case opcion do
      "1" ->
        codigo = IO.gets("Código: ") |> String.trim()
        nombre = IO.gets("Nombre: ") |> String.trim()
        precio = IO.gets("Precio: ") |> String.trim() |> String.to_integer()
        cantidad = IO.gets("Cantidad: ") |> String.trim() |> String.to_integer()

        case Producto.validar(%Producto{codigo: codigo, nombre: nombre, precio: precio, cantidad: cantidad}) do
          {:ok, prod} ->
            case Inventario.agregar(inv, prod) do
              {:ok, nuevo} -> ArchivoJSON.guardar(nuevo); loop(nuevo)
              {:error, msg} -> IO.puts(msg); loop(inv)
            end
          {:error, msg} -> IO.puts(msg); loop(inv)
        end

      "2" ->
        codigo = IO.gets("Código: ") |> String.trim()
        precio = IO.gets("Nuevo precio: ") |> String.trim() |> String.to_integer()
        cantidad = IO.gets("Nueva cantidad: ") |> String.trim() |> String.to_integer()
        case Inventario.actualizar(inv, codigo, %{precio: precio, cantidad: cantidad}) do
          {:ok, nuevo} -> ArchivoJSON.guardar(nuevo); loop(nuevo)
          {:error, msg} -> IO.puts(msg); loop(inv)
        end

      "3" ->
        codigo = IO.gets("Código: ") |> String.trim()
        {:ok, nuevo} = Inventario.eliminar(inv, codigo)
        ArchivoJSON.guardar(nuevo)
        loop(nuevo)

      "4" ->
        IO.inspect(Inventario.listar(inv))
        loop(inv)

      "5" ->
        IO.inspect(Inventario.productos_con_dos_vocales(inv))
        IO.inspect(Inventario.productos_misma_letra(inv))
        IO.inspect(Inventario.productos_bajo_precio(inv, 50000))
        IO.inspect(Inventario.top3_caros(inv))
        IO.puts(Inventario.productos_entre(inv, 20000, 80000))
        IO.inspect(Inventario.productos_por_rango(inv))
        loop(inv)

      "0" -> IO.puts("Saliendo...")

      _ -> IO.puts("Opción inválida"); loop(inv)
    end
  end
end
