defmodule Gimnasio.GestionArchivos do
  @archivo "socios.csv"

  def cargar do
    case File.read(@archivo) do
      {:ok, contenido} ->
        socios =
          contenido
          |> String.split("\n", trim: true)
          |> Enum.drop(1)
          |> Enum.map(&parsear_linea/1)
          |> Enum.reject(&is_nil/1)
          |> Enum.into(%{})
        {:ok, socios}

      {:error, :enoent} ->
        File.write(@archivo, "cedula,nombre,edad,clases\n")
        {:ok, %{}}

      {:error, razon} ->
        {:error, "Error leyendo archivo: #{inspect(razon)}"}
    end
  end

  def guardar(socios) do
    filas =
      socios
      |> Enum.map(fn {cedula, socio} ->
        clases = Enum.join(socio.clases, ";")
        "#{cedula},#{socio.nombre},#{socio.edad},#{clases}"
      end)

    contenido = (["cedula,nombre,edad,clases"] ++ filas) |> Enum.join("\n")

    case File.write(@archivo, contenido) do
      :ok         -> :ok
      {:error, r} -> {:error, "Error guardando: #{inspect(r)}"}
    end
  end

  defp parsear_linea(linea) do
    case String.split(linea, ",") do
      [cedula, nombre, edad_str, clases_str] ->
        clases = if clases_str == "", do: [], else: String.split(clases_str, ";")
        {cedula, %Gimnasio.Socio{
          nombre: nombre,
          edad: String.to_integer(edad_str),
          clases: clases
        }}
      _ -> nil
    end
  end
end
