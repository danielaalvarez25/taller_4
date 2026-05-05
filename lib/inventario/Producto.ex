defmodule Producto do

  defstruct [:codigo, :nombre, :precio, :cantidad]

  def validar(%Producto{codigo: c, nombre: n, precio: p, cantidad: q}) do
    cond do
      String.length(c) > 5 ->
        {:error, "El código debe tener máximo 5 caracteres"}

      p < 0 ->
        {:error, "El precio debe ser mayor o igual a 0"}

      q < 0 or not is_integer(q) ->
        {:error, "La cantidad debe ser un número entero >= 0"}

      true ->
        {:ok, %Producto{codigo: c, nombre: n, precio: p, cantidad: q}}
    end
  end
end
