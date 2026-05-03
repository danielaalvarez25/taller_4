defmodule Gimnasio.Menu do
  alias Gimnasio.Logica
  alias Gimnasio.GestionArchivos

  def iniciar do
    case GestionArchivos.cargar() do
      {:ok, socios} -> loop(socios)
      {:error, razon} -> IO.puts("Error al iniciar: #{razon}")
    end
  end

  defp loop(socios) do
    IO.puts("""
    \n===== GIMNASIO =====
    1. Crear socio
    2. Eliminar socio
    3. Buscar socio por cédula
    4. Listar todos los socios
    5. Inscribir socio en clase
    6. Desinscribir socio de clase
    7. Socios en una clase específica
    8. Clases de un socio
    0. Volver
    """)

    case IO.gets("Opción: ") |> String.trim() do
      "1" ->
        cedula = IO.gets("Cédula: ") |> String.trim()
        nombre = IO.gets("Nombre: ") |> String.trim()
        edad   = IO.gets("Edad: ") |> String.trim() |> String.to_integer()
        case Logica.agregar_socio(socios, cedula, nombre, edad) do
          {:ok, nuevos} -> IO.puts("✓ Socio creado"); loop(nuevos)
          {:error, r}   -> IO.puts("✗ Error: #{r}"); loop(socios)
        end

      "2" ->
        cedula = IO.gets("Cédula: ") |> String.trim()
        case Logica.eliminar_socio(socios, cedula) do
          {:ok, nuevos} -> IO.puts("✓ Eliminado"); loop(nuevos)
          {:error, r}   -> IO.puts("✗ Error: #{r}"); loop(socios)
        end

      "3" ->
        cedula = IO.gets("Cédula: ") |> String.trim()
        case Logica.buscar_socio(socios, cedula) do
          {:ok, s} ->
            IO.puts("Nombre: #{s.nombre} | Edad: #{s.edad} | Clases: #{Enum.join(s.clases, ", ")}")
            loop(socios)
          {:error, r} -> IO.puts("✗ #{r}"); loop(socios)
        end

      "4" ->
        case Logica.listar_socios(socios) do
          [] -> IO.puts("No hay socios registrados")
          lista ->
            Enum.each(lista, fn s ->
              IO.puts("#{s.nombre} | #{s.edad} años | Clases: #{Enum.join(s.clases, ", ")}")
            end)
        end
        loop(socios)

      "5" ->
        cedula = IO.gets("Cédula: ") |> String.trim()
        clase  = IO.gets("Clase: ") |> String.trim()
        case Logica.inscribir_clase(socios, cedula, clase) do
          {:ok, nuevos} -> IO.puts("✓ Inscrito en #{clase}"); loop(nuevos)
          {:error, r}   -> IO.puts("✗ Error: #{r}"); loop(socios)
        end

      "6" ->
        cedula = IO.gets("Cédula: ") |> String.trim()
        clase  = IO.gets("Clase: ") |> String.trim()
        case Logica.desinscribir_clase(socios, cedula, clase) do
          {:ok, nuevos} -> IO.puts("✓ Desinscrito de #{clase}"); loop(nuevos)
          {:error, r}   -> IO.puts("✗ Error: #{r}"); loop(socios)
        end

      "7" ->
        clase = IO.gets("Clase: ") |> String.trim()
        case Logica.socios_en_clase(socios, clase) do
          [] -> IO.puts("Ningún socio inscrito en #{clase}")
          lista -> Enum.each(lista, fn s -> IO.puts("#{s.nombre}") end)
        end
        loop(socios)

      "8" ->
        cedula = IO.gets("Cédula: ") |> String.trim()
        case Logica.clases_de_socio(socios, cedula) do
          {:ok, []}     -> IO.puts("Sin clases inscritas"); loop(socios)
          {:ok, clases} -> IO.puts("Clases: #{Enum.join(clases, ", ")}"); loop(socios)
          {:error, r}   -> IO.puts("✗ #{r}"); loop(socios)
        end

      "0" -> IO.puts("Saliendo del gimnasio...")
      _   -> IO.puts("Opción inválida"); loop(socios)
    end
  end
end
