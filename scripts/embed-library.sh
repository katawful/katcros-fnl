#!/usr/bin/env bash

set -xe

SRC_DIR=${SRC_DIR:-lua/nfnl}
SRC_PREFIX=${SRC_PREFIX:-'"nfnl\.'}

PROJECT=${PROJECT:-katcros-fnl}
DEST_DIR=${DEST_DIR:-$PROJECT/lua/$PROJECT}
DEST_PREFIX=${DEST_PREFIX:-"\"$PROJECT.nfnl."}

mkdir -p "$DEST_DIR"
cp -r "$SRC_DIR" "$DEST_DIR"
fd --no-ignore --extension .lua . "$DEST_DIR" --exec sd "$SRC_PREFIX" "$DEST_PREFIX"
