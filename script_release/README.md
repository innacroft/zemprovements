# Release Script BETA

Este script `release.sh` automatiza el proceso de creación de una nueva versión, actualización de archivos de versión, creación de etiquetas y pull requests en GitHub.

## Requisitos

Asegúrate de tener instaladas las siguientes herramientas en tu sistema:

- `jq`: Para manipulación de JSON.
- `gh` (GitHub CLI): Para interactuar con GitHub desde la línea de comandos.

### Instalación de Requisitos

#### Ubuntu/Debian

```bash
sudo apt-get update
sudo apt-get install -y jq
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
sudo chmod go+r [githubcli-archive-keyring.gpg](http://_vscodecontentref_/1)
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee [github-cli.list](http://_vscodecontentref_/2) > /dev/null
sudo apt update
sudo apt install gh
```
################################ 
- Agregar al archivo de aliases en linux
- En ubuntu buscar alguno de estos archivos `bash`: `~/.bashrc` o `~/.bash_aliases`, al final agregar:
```alias startrelease="/path_on_your_machine/release.sh"```
- Conceder permisos de ejecución  ```sudo chmod 755 /path_on_your_machine/bashes```
- Reiniciar la terminal
- Por último ejecutar el comando con el nombre asignado, en el ejemplo es startrelease


## Uso
En la variable VERSION_FILES_JSON , se debe especificar el repositorio con la ubicacion del archivo de versión, por defecto se encuentra así:
```
VERSION_FILES_JSON='[
  {"repo": "ms-catalog-zecore", "file": "package.json"},
  {"repo": "ms-packages-middleware", "file": "__version__.py"},
  {"repo": "ms-client-zecore", "file": "version.py"},
  {"repo": "catalog-erpnext", "file": "/catalog/__init__.py"}
]'
```
## ⚠️ Se debe ejecutar el comando desde el la raíz del repositorio, sobre la rama sobre la cual se desea hacer el release.⚠️

![Descripción del GIF](https://github.com/innacroft/zemprovements/blob/main/script_release/screen-capture.gif)
