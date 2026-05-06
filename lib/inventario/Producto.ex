defmodule Inventario.Producto do
  @enforce_keys [:codigo, :nombre, :precio, :cantidad]
  defstruct [:codigo, :nombre, :precio, :cantidad]

  def nuevo(codigo, nombre, precio, cantidad) do
    with :ok <- validar_codigo(codigo),
         :ok <- validar_nombre(nombre),
         :ok <- validar_precio(precio),
         :ok <- validar_cantidad(cantidad) do
      {:ok, %__MODULE__{codigo: codigo, nombre: nombre, precio: precio, cantidad: cantidad}}
    end
  end

  defp validar_codigo(c) when is_binary(c) and byte_size(c) in 1..5, do: :ok
  defp validar_codigo(_), do: {:error, "El código debe tener entre 1 y 5 caracteres"}

  defp validar_nombre(n) when is_binary(n) do
    if Regex.match?(~r/^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$/, n),
      do: :ok,
      else: {:error, "El nombre solo puede contener letras"}
  end
  defp validar_nombre(_), do: {:error, "Nombre inválido"}

  defp validar_precio(p) when is_number(p) and p >= 0, do: :ok
  defp validar_precio(_), do: {:error, "El precio debe ser mayor o igual a 0"}

  defp validar_cantidad(c) when is_integer(c) and c >= 0, do: :ok
  defp validar_cantidad(_), do: {:error, "La cantidad debe ser entero mayor o igual a 0"}
end
