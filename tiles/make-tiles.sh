#!/bin/bash

CENTROIDS_DIR=.tmp/centroids
rm -rf $CENTROIDS_DIR
mkdir -p $CENTROIDS_DIR

TMP_DIR=.tmp/tiles
rm -rf $TMP_DIR
mkdir -p $TMP_DIR

COUNTRY_SHP=tiles/input/ICRC_Admin0_WD_Internal/ICRC_Admin0_WD_Internal.shp
BOUNDARY_SHP=tiles/input/ICRC_Admin0_Borders_WD_Internal/ICRC_Admin0_Borders_WD_Internal.shp
ADM0_SHP=tiles/input/ICRC_Admin1_WD_Internal/ICRC_Admin1_WD_Internal.shp
SIMPLIFICATION=(4 8 32 80)
MIN_ZOOMS=(1 4 6 8)
MAX_ZOOMS=(3 5 7 10)

# Debugging with one simplification level
#SIMPLIFICATION=(50)

echo ""
echo "Creating simplified geojson files"
for PCT_SIMPLIFICATION in ${SIMPLIFICATION[@]}; do
  DIR=$TMP_DIR/$PCT_SIMPLIFICATION
  mkdir -p $DIR

  node_modules/.bin/mapshaper $COUNTRY_SHP \
    -simplify visvalingam $PCT_SIMPLIFICATION% \
    -proj wgs84 \
    -filter-islands min-vertices=2 remove-empty \
    -filter-fields ISO2,ISO3,NAME,NAME_ICRC \
    -o format=geojson $DIR/country.geojson

  node_modules/.bin/mapshaper $BOUNDARY_SHP \
    -simplify visvalingam $PCT_SIMPLIFICATION% \
    -proj wgs84 \
    -filter-islands min-vertices=2 remove-empty \
    -filter-fields OBJECTID,TYPE,TYPE2 \
    -o format=geojson $DIR/boundary.geojson

  node_modules/.bin/mapshaper $ADM0_SHP \
    -simplify visvalingam $PCT_SIMPLIFICATION% \
    -proj wgs84 \
    -filter-islands min-vertices=2 remove-empty \
    -filter-fields ISO2,Admin00Nam,Admin01Nam,OBJECTID,Admin01Cod \
    -o format=geojson $DIR/adm1.geojson
done

echo ""
echo "Creating centroid file"
cat $TMP_DIR/${SIMPLIFICATION[0]}/country.geojson | ./bin/centroid > $CENTROIDS_DIR/country-centroids.geojson
cat $TMP_DIR/${SIMPLIFICATION[0]}/adm1.geojson | ./bin/centroid > $CENTROIDS_DIR/adm1-centroids.geojson


echo ""
echo "Generating tiles"
for i in ${!SIMPLIFICATION[@]}; do
  PCT_SIMPLIFICATION=${SIMPLIFICATION[$i]}
  SOURCE_DIR=$TMP_DIR/$PCT_SIMPLIFICATION
  OUTPUT_DIR=$TMP_DIR/output/$PCT_SIMPLIFICATION
  mkdir -p $OUTPUT_DIR
  MIN_ZOOM=${MIN_ZOOMS[$i]}
  MAX_ZOOM=${MAX_ZOOMS[$i]}

  echo $MIN_ZOOM
  echo $MAX_ZOOM

  tippecanoe --projection EPSG:4326 \
    --named-layer=country:$SOURCE_DIR/country.geojson \
    --named-layer=adm1:$SOURCE_DIR/adm1.geojson \
    --named-layer=boundary:$SOURCE_DIR/boundary.geojson \
    --named-layer=country-centroids:$CENTROIDS_DIR/country-centroids.geojson \
    --named-layer=adm1-centroids:$CENTROIDS_DIR/adm1-centroids.geojson \
    --read-parallel \
    --drop-rate=0 \
    -z $MAX_ZOOM \
    -Z $MIN_ZOOM \
    --output $OUTPUT_DIR/tiles.mbtiles
done

tile-join -f -o $TMP_DIR/output/combined-go-tiles.mbtiles \
  $TMP_DIR/output/${SIMPLIFICATION[0]}/tiles.mbtiles \
  $TMP_DIR/output/${SIMPLIFICATION[1]}/tiles.mbtiles \
  $TMP_DIR/output/${SIMPLIFICATION[2]}/tiles.mbtiles \
  $TMP_DIR/output/${SIMPLIFICATION[3]}/tiles.mbtiles
