#!/bin/bash

TMP_DIR=.tmp/centroids
rm -rf $TMP_DIR

mkdir -p $TMP_DIR
cat .tmp/tiles/5/country.geojson | bin/centroid | bin/zip-object > $TMP_DIR/country-centroids.json
cat .tmp/tiles/5/adm1.geojson | bin/centroid | bin/zip-object > $TMP_DIR/adm1-centroids.json
