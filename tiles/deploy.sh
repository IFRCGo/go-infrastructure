#!/bin/bash

az storage blob upload-batch \
  --destination tiles \
  --source tiles/output \
  --content-type  "application/vnd.mapbox-vector-tile"
