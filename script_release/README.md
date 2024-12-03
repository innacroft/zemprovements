# Release Script BETA

Este script `release.sh` automatiza el proceso de creación de releases.

## Características
- Lista los últimos releases para saber cual sería la próxima versión
- Crea la versión del release respecto al número indicado
- Crea la etiqueta y la documentación del release y lo setea como *last release* 
- Crea y abre 3 pull requests hacia develop, staging y master 
- Agrega la documentación del release en master
- Asigna los pull requests y asigna la etiqueta de release a cada uno

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
Repositorios disponibles:
- https://github.com/luuna-tech/ms-catalog-zecore
- https://github.com/luuna-tech/ms-packages-middleware
- https://github.com/luuna-tech/ms-client-zecore
- https://github.com/luuna-tech/catalog-erpnext
- https://github.com/luuna-tech/zecore_custom_native_doctype

### NUEVOS REPOSITORIOS:
- En la variable VERSION_FILES_JSON , se debe especificar el repositorio con la ubicacion del archivo de versión, por defecto se encuentra así:
```
VERSION_FILES_JSON='[
  {"repo": "ms-catalog-zecore", "file": "package.json"},
  {"repo": "ms-packages-middleware", "file": "__version__.py"},
  {"repo": "ms-client-zecore", "file": "version.py"},
  {"repo": "catalog", "file": "catalog/__init__.py"}, # ERPNEXT
  {"repo": "zecore_custom_native_doctype", "file": "zecore_custom_native_doctype/__init__.py"} # ERPNEXT
]'
```
- Asegurarse de que la etiqueta release exista en el repositorio.
- Para casos especiales de archivos de version (formatos distintos) se deben agregar nuevas expresiones regulares.
## ⚠️ Se debe ejecutar el comando desde el la raíz del repositorio, sobre la rama sobre la cual se desea hacer el release.⚠️

## Ejecucion
- Al ejecutar el script primero se listarán los ultimos 3 releases realizados con ello se sabrá cual debería ser la versión más reciente. 
- Al continuar con el proceso se ingresa la versión deseada usando el formato 0.0.0 por ejemplo 1.0.0
- Al continuar se creará la rama de release si esta no existe, se cambiará la versión dentro del archivo de versión del proyecto, se hará push a la rama de release con la nueva versión
- Se crearán los pull requests hacia developm staging y master respectivamente, con tag de release y se autoasignará a la persona.
- Se creará el release como último dentro del listado de releases
- Se agregará la descripción del release de forma automática a la rama de MASTER

![Descripción del GIF](https://github.com/innacroft/zemprovements/blob/main/script_release/screen-capture.gif)
