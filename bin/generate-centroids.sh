#!/bin/bash

TMP_DIR=.tmp/centroids
rm -rf $TMP_DIR

mkdir -p $TMP_DIR

COUNTRY_SHP=tiles/input/natural-earth-shapefiles/ne_10m_admin_0_countries_lakes/ne_10m_admin_0_countries_lakes.shp

echo ""
echo "Creating simplified geojson files"

node_modules/.bin/mapshaper $COUNTRY_SHP \
  -filter-islands min-vertices=2 remove-empty \
  -o format=geojson $TMP_DIR/country.geojson

echo ""
echo "Reprojecting the geojson file"

cat $TMP_DIR/country.geojson \
  | node_modules/.bin/dirty-reproject --forward robinson \
  > $TMP_DIR/robinson-country.geojson

cat $TMP_DIR/robinson-country.geojson | bin/bounding-box | bin/zip-object > bounding-boxes.json
cat $TMP_DIR/robinson-country.geojson | bin/centroid | bin/zip-object > centroids.json
