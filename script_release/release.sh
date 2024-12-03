#!/bin/bash
################################################################
# LINUX:  
# sudo apt-get install jq
# sudo apt update
# https://github.com/cli/cli/blob/trunk/docs/install_linux.md
# sudo apt update
# sudo apt install gh
# gh auth login
# login with a web browser

REPO_NAME=$(basename $(git rev-parse --show-toplevel))
GITHUB_URL="https://github.com/luuna-tech"

echo "===== Repository '$REPO_NAME'====="
echo "Estos son los ultimos 3 tags releases disponibles:"
gh release list | head -n 3
echo -e "\n¿Deseas proceder? (Presiona Enter para confirmar, 'n' para cancelar y revertir): "
read -r CONFIRM

if [[ -z "$CONFIRM" || "$CONFIRM" == "y" || "$CONFIRM" == "Y" ]]; then
  echo "================================================"
else
  echo "Cancelado"
  exit 1
fi

# Función para validar el formato de la versión
validate_version_format() {
  if [[ ! "$1" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Error: La versión debe tener el formato '0.0.0'."
    exit 1
  fi
}

# Solicitar la versión si no se proporciona como argumento
if [ -z "$1" ]; then
  read -p "Introduce los 3 números de la nueva versión con el formato 0.0.0 " INPUT_VERSION
else
  INPUT_VERSION=$1
fi

# Validar el formato de la versión
validate_version_format "$INPUT_VERSION"

VERSION_TAG="v$INPUT_VERSION"
BRANCH="release/$VERSION_TAG"

# Determinar el remoto automáticamente
if git remote | grep -q "^origin$"; then
  REMOTE="origin"
elif git remote | grep -q "^upstream$"; then
  REMOTE="upstream"
else
  echo "Error: No se encontró ningún remoto llamado 'origin' o 'upstream'."
  exit 1
fi

cleanup() {
  echo "Error: Ocurrió un problema. Revertiendo cambios..."
  git checkout "$CURRENT_BRANCH" > /dev/null
  git branch -D "$BRANCH" > /dev/null
  exit 1
}

# Definir el JSON con las rutas de los archivos de versión y expresiones regulares
VERSION_FILES_JSON='[
  {"repo": "ms-catalog-zecore", "file": "package.json"},
  {"repo": "ms-packages-middleware", "file": "__version__.py"},
  {"repo": "ms-client-zecore", "file": "version.py"},
  {"repo": "catalog", "file": "catalog/__init__.py"},
  {"repo": "zecore_custom_native_doctype", "file": "zecore_custom_native_doctype/__init__.py"}
]'

# Obtener la ruta del archivo de versión y la expresión regular según el nombre del repositorio
REPO_INFO=$(echo "$VERSION_FILES_JSON" | jq -r --arg repo "$REPO_NAME" '.[] | select(.repo == $repo)')
VERSION_FILE=$(echo "$REPO_INFO" | jq -r '.file')

if [[ -z "$VERSION_FILE" || "$VERSION_FILE" == "null" ]]; then
  echo "Error: No se encuentra archivo de versión configurado para el repositorio '$REPO_NAME'."
  cleanup
fi


# Buscar o crear la rama
if git show-ref --verify --quiet "refs/heads/$BRANCH"; then
  git checkout "$BRANCH" > /dev/null
else
  CURRENT_BRANCH=$(git symbolic-ref --short HEAD)
  git checkout -b "$BRANCH" > /dev/null
  echo "Rama '$BRANCH' creada desde '$CURRENT_BRANCH'."
fi

# Leer la versión actual del archivo de versión
if [ -f "$VERSION_FILE" ]; then
  if [[ "$REPO_NAME" == "ms-catalog-zecore" ]]; then
    # CUSTOMIZED: version is not the only line and there are multiple versions in the file
    CURRENT_VERSION=$(jq -r 'select(.name == "ms-cart-zecore") | .version' "$VERSION_FILE")
  else
    CURRENT_VERSION=$(grep -oP '\b[0-9]+\.[0-9]+\.[0-9]+\b' "$VERSION_FILE")
  fi
  
  # Verificar si la versión actual está en el formato 0.0.0
  if [[ "$CURRENT_VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Versión actual encontrada en '$VERSION_FILE': $CURRENT_VERSION"
  else
    echo "Error: La versión en el archivo '$VERSION_FILE' no tiene el formato correcto ('0.0.0')."
    cleanup
    exit 1
  fi
else
  echo "Error: El archivo de versión '$VERSION_FILE' no existe."
  cleanup
  exit 1
fi


# Actualizar la versión en el archivo de versión
if [[ "$REPO_NAME" == "ms-catalog-zecore" ]]; then
  jq --arg new_version "$INPUT_VERSION" '.version = $new_version' "$VERSION_FILE" > tmp.$$.json && mv tmp.$$.json "$VERSION_FILE"
else
  sed -i "s/\b[0-9]\+\.[0-9]\+\.[0-9]\+\b/$INPUT_VERSION/" "$VERSION_FILE"
fi
git add "$VERSION_FILE"
git commit -m "Release/v$INPUT_VERSION"
echo "Versión actualizada en el archivo '$VERSION_FILE'."

TAG_MESSAGE="Version $VERSION_TAG"
git tag -a "$VERSION_TAG" -m "$TAG_MESSAGE"
echo "Etiqueta '$VERSION_TAG' creada."

# Confirmación antes del push
echo -e "\nPasos a seguir:"
echo "1. Se realizará el push de la rama '$BRANCH'."
echo "2. Se hará push de la etiqueta '$VERSION_TAG'."
echo "3. Se crearán pull requests para develop, staging y master."
echo -e "\n¿Deseas proceder? (Presiona Enter para confirmar, 'n' para cancelar y revertir): "
read -r CONFIRM

if [[ -z "$CONFIRM" || "$CONFIRM" == "y" || "$CONFIRM" == "Y" ]]; then
  git push "$REMOTE" "$BRANCH" > /dev/null
  git push "$REMOTE" "$VERSION_TAG" > /dev/null
  echo "Push completado en el remoto '$REMOTE'."
  
  # set release as latest and generate notes
  gh release create "$VERSION_TAG" --title "$VERSION_TAG" --generate-notes --latest
  # save release notes
  RELEASE_NOTES=$(gh release view "$VERSION_TAG" --json body --jq .body)

  for TARGET_BRANCH in develop staging master; do
    if [[ "$TARGET_BRANCH" == "master" ]]; then
    # apply release notes to master's PR body
      PR_BODY="$RELEASE_NOTES"
    else
      PR_BODY="Version $VERSION_TAG."
    fi
    PR_TITLE="Release/$VERSION_TAG [$TARGET_BRANCH]"
    gh pr create --title "$PR_TITLE" --body "$PR_BODY" --base "$TARGET_BRANCH" --head "$BRANCH" --label "release" --assignee "@me"
    echo " ✅ Pull request creado para '$TARGET_BRANCH'."
  done
  echo "Release Finalizado ✅ "
  gh release list | head -n 1

else
  echo "Push cancelado."
  cleanup
fi
