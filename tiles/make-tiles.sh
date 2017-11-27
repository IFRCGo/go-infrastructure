#!/bin/bash

TMP_DIR=tmp/tiles
rm -rf $TMP_DIR

mkdir -p $TMP_DIR

COUNTRY_SHP=tiles/input/natural-earth-shapefiles/ne_10m_admin_0_countries_lakes/ne_10m_admin_0_countries_lakes.shp
POPULATION_SHP=tiles/input/natural-earth-shapefiles/ne_10m_populated_places_simple/ne_10m_populated_places_simple.shp
POPULATION_THRESHOLDS=(5000000 500000 10000 1000)
SIMPLIFICATION=(5 10 50 100)
MIN_ZOOMS=(1 4 6 8)
MAX_ZOOMS=(3 5 7 10)

# Debugging with one simplification level
# SIMPLIFICATION=(5)


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
  cat $DIR/population.geojson \
    | ./bin/filter-by-population --threshold $POPULATION_THRESHOLD \
    > $DIR/filtered-population.geojson
done


echo ""
echo "Reprojecting"
for PCT_SIMPLIFICATION in ${SIMPLIFICATION[@]}; do
  DIR=$TMP_DIR/$PCT_SIMPLIFICATION

  cat $DIR/country.geojson \
    | node_modules/.bin/dirty-reproject --forward robinson \
    > $DIR/robinson-country.geojson

  cat $DIR/filtered-population.geojson \
    | node_modules/.bin/dirty-reproject --forward robinson \
    > $DIR/robinson-population.geojson
done


echo ""
echo "Generating tiles"
for i in ${!SIMPLIFICATION[@]}; do
  PCT_SIMPLIFICATION=${SIMPLIFICATION[$i]}
  DIR=$TMP_DIR/$PCT_SIMPLIFICATION
  OUTPUT_DIR=$TMP_DIR/output/$PCT_SIMPLIFICATION
  mkdir -p $OUTPUT_DIR
  MIN_ZOOM=${MIN_ZOOMS[$i]}
  MAX_ZOOM=${MAX_ZOOMS[$i]}

  echo $MIN_ZOOM
  echo $MAX_ZOOM

  tippecanoe --projection EPSG:4326 \
    --named-layer=country:$DIR/robinson-country.geojson \
    --named-layer=population:$DIR/robinson-population.geojson \
    --drop-rate=0 \
    --output-to-directory=$OUTPUT_DIR \
    --no-tile-compression \
    --maximum-zoom=$MAX_ZOOM \
    --minimum-zoom=$MIN_ZOOM

done
