defmodule InventarioTest do
  use ExUnit.Case
  alias Inventario.Producto
  alias Inventario.Logica

  setup do
    productos = %{
      "P001" => %Producto{codigo: "P001", nombre: "Arroz", precio: 3000.0, cantidad: 10},
      "P002" => %Producto{codigo: "P002", nombre: "Leche", precio: 120000.0, cantidad: 5},
      "P003" => %Producto{codigo: "P003", nombre: "Cafe", precio: 75000.0, cantidad: 8}
    }
    {:ok, productos: productos}
  end

  test "no permite código duplicado", %{productos: p} do
    assert {:error, _} = Logica.agregar(p, "P001", "Nuevo", 1000.0, 5)
  end

  test "validación: código mayor a 5 chars" do
    assert {:error, _} = Producto.nuevo("CODIGO123", "Arroz", 1000.0, 5)
  end

  test "validación: nombre con números falla" do
    assert {:error, _} = Producto.nuevo("P001", "Arroz123", 1000.0, 5)
  end

  test "top 3 más caros retorna ordenados", %{productos: p} do
    top = Logica.top_tres_caros(p)
    precios = Enum.map(top, & &1.precio)
    assert precios == Enum.sort(precios, :desc)
  end

  test "agrupar por precio clasifica correctamente", %{productos: p} do
    grupos = Logica.agrupar_por_precio(p)
    assert length(grupos.menores_50000) == 1
    assert length(grupos.entre_50000_100000) == 1
    assert length(grupos.mayores_100000) == 1
  end
end
