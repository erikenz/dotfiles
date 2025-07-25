#!/usr/bin/env bash

if [[ "$SHELL" =~ .*fish$ ]]; then
  exit 0
fi

chsh -s "$(which fish)"
