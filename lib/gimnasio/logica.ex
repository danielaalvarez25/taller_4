defmodule Gimnasio.Logica do
  alias Gimnasio.Socio
  alias Gimnasio.GestionArchivos

  def agregar_socio(socios, cedula, nombre, edad) do
    if Map.has_key?(socios, cedula) do
      {:error, "Cédula duplicada"}
    else
      case Socio.nuevo(nombre, edad) do
        {:ok, socio} ->
          nuevos = Map.put(socios, cedula, socio)
          GestionArchivos.guardar(nuevos)
          {:ok, nuevos}
        {:error, razon} -> {:error, razon}
      end
    end
  end

  def eliminar_socio(socios, cedula) do
    if Map.has_key?(socios, cedula) do
      nuevos = Map.delete(socios, cedula)
      GestionArchivos.guardar(nuevos)
      {:ok, nuevos}
    else
      {:error, "Socio no encontrado"}
    end
  end

  def buscar_socio(socios, cedula) do
    case Map.get(socios, cedula) do
      nil   -> {:error, "Socio no encontrado"}
      socio -> {:ok, socio}
    end
  end

  def inscribir_clase(socios, cedula, clase) do
    case Map.get(socios, cedula) do
      nil -> {:error, "Socio no encontrado"}
      socio ->
        case Socio.inscribir_clase(socio, clase) do
          {:ok, actualizado} ->
            nuevos = Map.put(socios, cedula, actualizado)
            GestionArchivos.guardar(nuevos)
            {:ok, nuevos}
          {:error, razon} -> {:error, razon}
        end
    end
  end

  def desinscribir_clase(socios, cedula, clase) do
    case Map.get(socios, cedula) do
      nil -> {:error, "Socio no encontrado"}
      socio ->
        case Socio.desinscribir_clase(socio, clase) do
          {:ok, actualizado} ->
            nuevos = Map.put(socios, cedula, actualizado)
            GestionArchivos.guardar(nuevos)
            {:ok, nuevos}
          {:error, razon} -> {:error, razon}
        end
    end
  end

  def listar_socios(socios), do: Map.values(socios)

  def socios_en_clase(socios, clase) do
    socios
    |> Map.values()
    |> Enum.filter(&Socio.tiene_clase?(&1, clase))
  end

  def clases_de_socio(socios, cedula) do
    case Map.get(socios, cedula) do
      nil   -> {:error, "Socio no encontrado"}
      socio -> {:ok, socio.clases}
    end
  end
end
