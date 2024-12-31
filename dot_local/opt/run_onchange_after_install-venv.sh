#!/bin/sh

set -eu

export VIRTUAL_ENV=~/.local/opt/python

[ -d "${VIRTUAL_ENV}" ] || python3 -m venv "${VIRTUAL_ENV}"

"${VIRTUAL_ENV}/bin/pip3" install yt-dlp
