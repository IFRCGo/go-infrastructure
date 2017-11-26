#!/bin/bash

TMP_DIR=tmp/tiles
rm -rf $TMP_DIR

mkdir -p $TMP_DIR

COUNTRY_SHP=tiles/input/natural-earth-shapefiles/ne_10m_admin_0_countries_lakes/ne_10m_admin_0_countries_lakes.shp
POPULATION_SHP=tiles/input/natural-earth-shapefiles/ne_10m_populated_places_simple/ne_10m_populated_places_simple.shp
#SIMPLIFICATION=(100 50 10 5)
#POPULATION_THRESHOLDS=(1000 10000 100000 5000000)
SIMPLIFICATION=(5)
POPULATION_THRESHOLDS=(5000000)


echo ""
echo "Creating simplified geojson files"
for PCT_SIMPLIFICATION in ${SIMPLIFICATION[@]}; do
  DIR=$TMP_DIR/$PCT_SIMPLIFICATION
  mkdir -p $DIR

  node_modules/.bin/mapshaper $COUNTRY_SHP \
    -simplify visvalingam $PCT_SIMPLIFICATION% \
    -filter-islands min-vertices=2 remove-empty \
    -o format=geojson $DIR/country.geojson

  node_modules/.bin/mapshaper $POPULATION_SHP \
    -o format=geojson $DIR/population.geojson
done


echo ""
echo "Filtering cities by population"
for i in ${!SIMPLIFICATION[@]}; do
  PCT_SIMPLIFICATION=${SIMPLIFICATION[$i]}
  DIR=$TMP_DIR/$PCT_SIMPLIFICATION
  POPULATION_THRESHOLD=${POPULATION_THRESHOLDS[$i]}
done


echo ""
echo "Reprojecting"
for PCT_SIMPLIFICATION in ${SIMPLIFICATION[@]}; do
  DIR=$TMP_DIR/$PCT_SIMPLIFICATION

  cat $DIR/country.geojson \
    | node_modules/.bin/dirty-reproject --forward robinson \
    > $DIR/robinson-country.geojson

  cat $DIR/population.geojson \
    | node_modules/.bin/dirty-reproject --forward robinson \
    > $DIR/robinson-population.geojson
done


echo ""
echo "Generating tiles"

OUTPUT_DIR=$TMP_DIR/output
mkdir -p $OUTPUT_DIR

tippecanoe --projection EPSG:3857 \
  --named-layer=country:$TMP_DIR/5/robinson-country.geojson \
  --named-layer=population:$TMP_DIR/5/robinson-population.geojson \
  --read-parallel \
  --no-polygon-splitting \
  --drop-rate=0 \
  --output-to-directory=$OUTPUT_DIR \
  --no-tile-compression \
  --maximum-zoom=1 \
  --minimum-zoom=3
