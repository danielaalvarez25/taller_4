# TallerElixir

# Taller 4 - Structs, Mapas y Manejo de Archivos en Elixir

  ## Integrantes
- Daniela Alvarez Acosta
- Juan jose Gomez Martinez

## Descripción de la solución
Se desarrollaron dos sistemas en Elixir organizados en un proyecto Mix:

El primero es un sistema de gestión de socios para un gimnasio, donde se pueden
crear socios, inscribirlos en clases y consultar información. Los datos se guardan
en un archivo CSV que se carga al iniciar y se actualiza automáticamente.

El segundo es un sistema de inventario de productos con operaciones CRUD y consultas
funcionales como agrupar por precio, filtrar por vocales en el nombre y obtener los
productos más caros. Los datos se guardan en un archivo JSON usando la librería Jason.

## Aprendizajes
- Uso de structs y mapas en Elixir para modelar entidades del mundo real
- Manejo de archivos CSV y JSON para persistencia de datos
- Organización de proyectos con Mix y Application
- Manejo de errores con tuplas {:ok, resultado} y {:error, motivo}
- Uso de Enum para consultas funcionales sobre colecciones
- Separación de responsabilidades en módulos independientes
- Pruebas unitarias con ExUnit

## Uso de Inteligencia Artificial
Se utilizó inteligencia artificial como apoyo durante el desarrollo del taller.
La IA nos ayudo a:
- Estructurar los módulos siguiendo buenas prácticas de Elixir
- Entender el manejo de archivos CSV y JSON
- Organizar el proyecto con Mix y Application
- Identificar y corregir errores de compilación
- Sugerir el manejo de errores con tuplas y separación de responsabilidades