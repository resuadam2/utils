# Repositorio con Scripts de utilidades varias

## 📦 Script para descomprimir carpetas con zips

[El script descomprimir.py](./descomprimir.py)

Script en Python al que podemos pasarle una ruta y buscará todos los zips que haya dentro de esa ruta o dentro de los directorios que estén dentro de esa ruta y los descomprimirá todos en la misma ruta o subruta en la que estén.

Especialmente útil para cuándo se hacen entregas en moodle en zip y poder descomprimir todos los archivos de una sola vez a la hora de corregir sin tener que ir uno por uno.

Uso:
```
python descomprimiry.py ruta_principal
```

## 🤖 Script de automatización de evaluación de prácticas Java

[El Script grade.sh](grade.sh)

Este script automatiza el proceso de evaluación de prácticas Java empaquetadas como archivos `.zip`. Se espera que los proyectos usen Maven como sistema de construcción.

### 📦 ¿Qué hace?

1. **Descomprime** el archivo `.zip` recibido como parámetro.
2. **Localiza automáticamente** el archivo `pom.xml` del proyecto.
3. Usa **Maven** (o su wrapper `mvnw`, si está presente) para:
   - Limpiar el proyecto.
   - Ejecutar los tests con `mvn test`.
4. **Muestra por pantalla** un resumen con:
   - Número total de tests ejecutados.
   - Tests fallidos, con el nombre del método correspondiente.
   - Tests con errores o ignorados.
5. **Devuelve código de salida `0` si todos los tests pasan**, o `1` si alguno falla.

### 🚀 Uso

```bash
./grade.sh nombre_del_archivo.zip
```

## 📄 Requisitos

- Tener instalado:
  - `bash`
  - `unzip`
  - `maven` (si el proyecto no incluye el wrapper `mvnw`)
- El archivo `.zip` debe contener un proyecto Java con estructura estándar de Maven (`src/main/java`, `src/test/java`, etc.).

## 📁 Estructura esperada

```
Ejemplo.zip
└── Ejemplo/
    ├── pom.xml
    ├── src/
    │   ├── main/java/...
    │   └── test/java/...
    └── ...
```