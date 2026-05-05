defmodule ArchivoJSON do
  @file "productos.json"

  def cargar() do
    case File.read(@file) do
      {:ok, contenido} ->
        Jason.decode!(contenido, keys: :atoms)
      _ ->
        %{}
    end
  end

  def guardar(inventario) do
    File.write!(@file, Jason.encode!(inventario))
  end
end
