defmodule Inventario.Menu do
  alias Inventario.Logica
  alias Inventario.ArchivoJSON

  def iniciar do
    case ArchivoJSON.cargar() do
      {:ok, productos} -> loop(productos)
      {:error, razon}  -> IO.puts("Error al iniciar: #{razon}")
    end
  end

  defp loop(productos) do
    IO.puts("""
    \n===== INVENTARIO =====
    1.  Agregar producto
    2.  Actualizar producto
    3.  Eliminar producto
    4.  Listar productos
    5.  Productos con 2+ vocales en nombre
    6.  Productos con misma letra inicio y fin
    7.  Productos con precio menor a...
    8.  Top 3 productos más caros
    9.  Productos con precio entre dos valores
    10. Agrupar por rango de precio
    0.  Volver
    """)

    case IO.gets("Opción: ") |> String.trim() do
      "1" ->
        codigo   = IO.gets("Código (max 5 chars): ") |> String.trim()
        nombre   = IO.gets("Nombre (solo letras): ") |> String.trim()
        precio   = IO.gets("Precio: ") |> String.trim() |> String.to_float()
        cantidad = IO.gets("Cantidad: ") |> String.trim() |> String.to_integer()
        case Logica.agregar(productos, codigo, nombre, precio, cantidad) do
          {:ok, nuevos} -> IO.puts("✓ Producto agregado"); loop(nuevos)
          {:error, r}   -> IO.puts("✗ Error: #{r}"); loop(productos)
        end

      "2" ->
        codigo   = IO.gets("Código a actualizar: ") |> String.trim()
        nombre   = IO.gets("Nuevo nombre: ") |> String.trim()
        precio   = IO.gets("Nuevo precio: ") |> String.trim() |> String.to_float()
        cantidad = IO.gets("Nueva cantidad: ") |> String.trim() |> String.to_integer()
        case Logica.actualizar(productos, codigo, nombre, precio, cantidad) do
          {:ok, nuevos} -> IO.puts("✓ Actualizado"); loop(nuevos)
          {:error, r}   -> IO.puts("✗ Error: #{r}"); loop(productos)
        end

      "3" ->
        codigo = IO.gets("Código a eliminar: ") |> String.trim()
        case Logica.eliminar(productos, codigo) do
          {:ok, nuevos} -> IO.puts("✓ Eliminado"); loop(nuevos)
          {:error, r}   -> IO.puts("✗ Error: #{r}"); loop(productos)
        end

      "4" ->
        case Logica.listar(productos) do
          [] -> IO.puts("No hay productos")
          lista ->
            Enum.each(lista, fn p ->
              IO.puts("#{p.codigo} | #{p.nombre} | $#{p.precio} | #{p.cantidad} uds")
            end)
        end
        loop(productos)

      "5" ->
        Logica.con_dos_vocales(productos)
        |> Enum.each(fn {c, n} -> IO.puts("#{c} - #{n}") end)
        loop(productos)

      "6" ->
        Logica.misma_letra_inicio_fin(productos)
        |> Enum.each(fn {c, n} -> IO.puts("#{c} - #{n}") end)
        loop(productos)

      "7" ->
        valor = IO.gets("Precio máximo: ") |> String.trim() |> String.to_float()
        Logica.precio_menor_a(productos, valor)
        |> Enum.each(fn p -> IO.puts("#{p.nombre} - $#{p.precio}") end)
        loop(productos)

      "8" ->
        Logica.top_tres_caros(productos)
        |> Enum.each(fn p -> IO.puts("#{p.nombre} - $#{p.precio}") end)
        loop(productos)

      "9" ->
        min = IO.gets("Precio mínimo: ") |> String.trim() |> String.to_float()
        max = IO.gets("Precio máximo: ") |> String.trim() |> String.to_float()
        IO.puts(Logica.precio_entre(productos, min, max))
        loop(productos)

      "10" ->
        grupos = Logica.agrupar_por_precio(productos)
        IO.puts("Menores a 50000: #{length(grupos.menores_50000)}")
        IO.puts("Entre 50000 y 100000: #{length(grupos.entre_50000_100000)}")
        IO.puts("Mayores a 100000: #{length(grupos.mayores_100000)}")
        loop(productos)

      "0" -> IO.puts("Saliendo del inventario...")
      _   -> IO.puts("Opción inválida"); loop(productos)
    end
  end
end
