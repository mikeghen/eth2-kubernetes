#!/usr/bin/env bash
echo "Starting Lighthouse"

mv /root/pyrmont/validators /root/.lighthouse/pyrmont/validators

exec lighthouse $@
