defmodule Inventario.Logica do
  alias Inventario.Producto
  alias Inventario.ArchivoJSON

  def agregar(productos, codigo, nombre, precio, cantidad) do
    if Map.has_key?(productos, codigo) do
      {:error, "Código duplicado"}
    else
      case Producto.nuevo(codigo, nombre, precio, cantidad) do
        {:ok, prod} ->
          nuevos = Map.put(productos, codigo, prod)
          ArchivoJSON.guardar(nuevos)
          {:ok, nuevos}
        {:error, razon} -> {:error, razon}
      end
    end
  end

  def actualizar(productos, codigo, nombre, precio, cantidad) do
    case Map.get(productos, codigo) do
      nil -> {:error, "Producto no encontrado"}
      _ ->
        case Producto.nuevo(codigo, nombre, precio, cantidad) do
          {:ok, prod} ->
            nuevos = Map.put(productos, codigo, prod)
            ArchivoJSON.guardar(nuevos)
            {:ok, nuevos}
          {:error, razon} -> {:error, razon}
        end
    end
  end

  def eliminar(productos, codigo) do
    if Map.has_key?(productos, codigo) do
      nuevos = Map.delete(productos, codigo)
      ArchivoJSON.guardar(nuevos)
      {:ok, nuevos}
    else
      {:error, "Producto no encontrado"}
    end
  end

  def listar(productos), do: Map.values(productos)

  def con_dos_vocales(productos) do
    productos
    |> Enum.filter(fn {_, p} ->
      length(Regex.scan(~r/[aeiouáéíóúAEIOUÁÉÍÓÚ]/, p.nombre)) >= 2
    end)
    |> Enum.map(fn {c, p} -> {c, p.nombre} end)
  end

  def misma_letra_inicio_fin(productos) do
    productos
    |> Enum.filter(fn {_, p} ->
      n = String.downcase(p.nombre) |> String.replace(" ", "")
      String.first(n) == String.last(n)
    end)
    |> Enum.map(fn {c, p} -> {c, p.nombre} end)
  end

  def precio_menor_a(productos, valor) do
    productos
    |> Enum.filter(fn {_, p} -> p.precio < valor end)
    |> Enum.map(fn {_, p} -> p end)
  end

  def top_tres_caros(productos) do
    productos
    |> Map.values()
    |> Enum.sort_by(& &1.precio, :desc)
    |> Enum.take(3)
  end

  def precio_entre(productos, min, max) do
    productos
    |> Enum.filter(fn {_, p} -> p.precio >= min and p.precio <= max end)
    |> Enum.map(fn {_, p} -> "#{p.nombre} - #{p.precio}" end)
    |> Enum.join(", ")
  end

  def agrupar_por_precio(productos) do
    vals = Map.values(productos)
    %{
      menores_50000:      Enum.filter(vals, fn p -> p.precio < 50000 end),
      entre_50000_100000: Enum.filter(vals, fn p -> p.precio >= 50000 and p.precio <= 100000 end),
      mayores_100000:     Enum.filter(vals, fn p -> p.precio > 100000 end)
    }
  end
end
