#!/usr/bin/env bash
set -euo pipefail

SRC_DIR="/home/lars/code/elysian_framework/ElysianFramework/"
DEST_DIR="/home/lars/Games/battlenet/drive_c/Program Files (x86)/World of Warcraft/_retail_/Interface/AddOns/ElysianFramework/"

rsync -a --delete "$SRC_DIR" "$DEST_DIR"
