# Release Script

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
- Para `bash`: `~/.bashrc` o `~/.bash_aliases`
- Por último ejecutar el comando con el nombre asignado, en el ejemplo es startrelease


## Uso
![Descripción del GIF](https://github.com/innacroft/improvements/blob/main/screen-capture.gif)
