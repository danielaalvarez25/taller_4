defmodule Inventario.ArchivoJSON do
  @ruta "productos.json"

  def cargar do
    case File.read(@ruta) do
      {:ok, contenido} ->
        case Jason.decode(contenido) do
          {:ok, lista} ->
            productos =
              lista
              |> Enum.map(&parsear/1)
              |> Enum.reject(&is_nil/1)
              |> Enum.into(%{})
            {:ok, productos}
          {:error, _} ->
            {:ok, %{}}
        end

      {:error, :enoent} ->
        File.write(@ruta, "[]")
        {:ok, %{}}

      {:error, razon} ->
        {:error, "Error leyendo JSON: #{inspect(razon)}"}
    end
  end

  def guardar(productos) do
    lista =
      productos
      |> Enum.map(fn {_, p} ->
        %{
          "codigo"   => p.codigo,
          "nombre"   => p.nombre,
          "precio"   => p.precio,
          "cantidad" => p.cantidad
        }
      end)

    case Jason.encode(lista, pretty: true) do
      {:ok, json}     -> File.write(@ruta, json)
      {:error, razon} -> {:error, "Error codificando JSON: #{inspect(razon)}"}
    end
  end

  defp parsear(%{"codigo" => c, "nombre" => n, "precio" => p, "cantidad" => cant}) do
    {c, %Inventario.Producto{codigo: c, nombre: n, precio: p, cantidad: cant}}
  end
  defp parsear(_), do: nil
end
