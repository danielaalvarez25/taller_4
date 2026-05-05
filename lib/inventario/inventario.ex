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
end
