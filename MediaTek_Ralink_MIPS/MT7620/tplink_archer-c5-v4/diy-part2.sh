#!/bin/bash

# ---------- sync config ----------
make oldconfig
cat ./.config
