defmodule Inventario do
  alias Producto

  def agregar(inventario, producto) do
    if Map.has_key?(inventario, producto.codigo) do
      {:error, "Código repetido"}
    else
      {:ok, Map.put(inventario, producto.codigo, producto)}
    end
  end

  def actualizar(inventario, codigo, cambios) do
    case Map.get(inventario, codigo) do
      nil -> {:error, "Producto no encontrado"}
      prod ->
        actualizado = Map.merge(prod, cambios)
        {:ok, Map.put(inventario, codigo, actualizado)}
    end
  end

  def eliminar(inventario, codigo) do
    {:ok, Map.delete(inventario, codigo)}
  end

  def listar(inventario) do
    Map.values(inventario)
  end

  defmodule Inventario do
    # Reporte 1: productos con al menos dos vocales en el nombre
    def productos_con_dos_vocales(inventario) do
      inventario
      |> Enum.filter(fn {_codigo, prod} ->
        String.downcase(prod.nombre)
        |> String.graphemes()
        |> Enum.count(&(&1 in ["a","e","i","o","u"])) >= 2
      end)
      |> Enum.map(fn {c, p} -> {c, p.nombre} end)
    end

    # Reporte 2: productos cuyo nombre empieza y termina con la misma letra
    def productos_misma_letra(inventario) do
      inventario
      |> Enum.filter(fn {_c, p} ->
        nombre = String.downcase(p.nombre)
        String.first(nombre) == String.last(nombre)
      end)
    end

    # Reporte 3: productos por debajo de un precio dado
    def productos_bajo_precio(inventario, limite) do
      inventario
      |> Enum.filter(fn {_c, p} -> p.precio < limite end)
    end

    # Reporte 4: los tres productos más caros
    def top3_caros(inventario) do
      inventario
      |> Enum.sort_by(fn {_c, p} -> p.precio end, :desc)
      |> Enum.take(3)
    end

    # Reporte 5: cadena con nombre y precio de productos entre dos valores
    def productos_entre(inventario, min, max) do
      inventario
      |> Enum.filter(fn {_c, p} -> p.precio >= min and p.precio <= max end)
      |> Enum.map(fn {_c, p} -> "#{p.nombre}: #{p.precio}" end)
      |> Enum.join(", ")
    end

    # Reporte 6: agrupados por rango de precio
    def productos_por_rango(inventario) do
      %{
        menores_50000: Enum.filter(inventario, fn {_c, p} -> p.precio < 50000 end),
        entre_50000_100000: Enum.filter(inventario, fn {_c, p} -> p.precio >= 50000 and p.precio <= 100000 end),
        mayores_100000: Enum.filter(inventario, fn {_c, p} -> p.precio > 100000 end)
      }
    end
  end

end
