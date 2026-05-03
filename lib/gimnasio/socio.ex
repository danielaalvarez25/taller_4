defmodule Gimnasio.Socio do
  @enforce_keys [:nombre, :edad]
  defstruct [:nombre, :edad, clases: []]

  def nuevo(nombre, edad) when is_binary(nombre) and nombre != "" and edad > 0 and edad < 120 do
    {:ok, %__MODULE__{nombre: nombre, edad: edad}}
  end

  def nuevo(_, _), do: {:error, "Datos inválidos: nombre no vacío y edad entre 1 y 119"}

  def inscribir_clase(%__MODULE__{clases: clases} = socio, clase) do
    if tiene_clase?(socio, clase) do
      {:error, "Ya está inscrito en #{clase}"}
    else
      {:ok, %{socio | clases: clases ++ [clase]}}
    end
  end

  def desinscribir_clase(%__MODULE__{clases: clases} = socio, clase) do
    if tiene_clase?(socio, clase) do
      {:ok, %{socio | clases: List.delete(clases, clase)}}
    else
      {:error, "No está inscrito en #{clase}"}
    end
  end

  def tiene_clase?(%__MODULE__{clases: clases}, clase) do
    Enum.member?(clases, clase)
  end
end
