defmodule GimnasioTest do
  use ExUnit.Case
  alias Gimnasio.Socio
  alias Gimnasio.Logica

  test "crear socio válido" do
    assert {:ok, %Socio{nombre: "Juan", edad: 25}} = Socio.nuevo("Juan", 25)
  end

  test "crear socio con edad inválida retorna error" do
    assert {:error, _} = Socio.nuevo("Juan", -5)
    assert {:error, _} = Socio.nuevo("Juan", 0)
  end

  test "inscribir clase nueva" do
    {:ok, socio} = Socio.nuevo("Ana", 30)
    assert {:ok, actualizado} = Socio.inscribir_clase(socio, "Yoga")
    assert Socio.tiene_clase?(actualizado, "Yoga")
  end

  test "no permite inscribir clase duplicada" do
    {:ok, socio} = Socio.nuevo("Ana", 30)
    {:ok, socio} = Socio.inscribir_clase(socio, "Yoga")
    assert {:error, _} = Socio.inscribir_clase(socio, "Yoga")
  end

  test "desinscribir clase existente" do
    {:ok, socio} = Socio.nuevo("Ana", 30)
    {:ok, socio} = Socio.inscribir_clase(socio, "Yoga")
    assert {:ok, actualizado} = Socio.desinscribir_clase(socio, "Yoga")
    refute Socio.tiene_clase?(actualizado, "Yoga")
  end
end
