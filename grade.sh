#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Uso: $0 entrega_alumno.zip"
  exit 1
fi

ZIP="$1"
WORKDIR=$(mktemp -d)
unzip -q "$ZIP" -d "$WORKDIR"

# Localizar pom.xml
PROJECT_DIR=$(find "$WORKDIR" -maxdepth 3 -type f -name pom.xml | head -n1 | xargs dirname || true)
[[ -z "$PROJECT_DIR" ]] && { echo "❌ No se encontró pom.xml."; exit 1; }

cd "$PROJECT_DIR"

# Determinar comando Maven
if [[ -x "./mvnw" ]]; then
  MVNCMD="./mvnw"
else
  MVNCMD="mvn"
fi

echo "🏁 Ejecutando tests con Maven..." > resultado.txt

$MVNCMD clean test >> resultado.txt 2>&1 || echo "⚠️ Maven finalizó con errores." >> resultado.txt

if [[ -f resultado.txt ]]; then
  echo ""
  echo "📄 Resultados de los test:"
  grep -E "Tests run:|Failures:|Errors:|Skipped:|BUILD SUCCESS|BUILD FAILURE" resultado.txt | sed 's/\[INFO\] //g'

  echo ""

  # Extraer tests con fallo
  echo "📊 Tests fallidos:"
  grep -E "<<< FAILURE!" resultado.txt | sed -E 's/^\[ERROR\] +([^ ]+)\(([^)]+)\) +Time elapsed:.*<<< FAILURE!/\1 (\2)/' || echo "  ✅ No hay Tests fallidos."
  echo ""

  # Extraer tests con error
  echo "📊 Tests con errores:"
  grep -E "<<< ERROR!" resultado.txt | sed -E 's/^\[ERROR\] +([^ ]+)\(([^)]+)\) +Time elapsed:.*<<< ERROR!/\1 (\2)/' || echo "  ✅ No hay Tests con errores."
  echo ""

  # Extraer tests ignorados
  echo "📊 Tests ignorados:"
  grep -E "Tests skipped:" resultado.txt | sed -E 's/^\[INFO\] Tests skipped: (.*)/  - \1/' || echo "  ✅ No hay Tests ignorados."
  echo ""

else
  echo "❌ No se generó resultado.txt. Algo fue mal al ejecutar Maven."
  exit 1
fi

if grep -q "BUILD SUCCESS" resultado.txt; then
  echo "✅ Todos los tests pasan."
  exit 0
else
  echo "❌ Fallos detectados en los tests."
  exit 1
fi
g