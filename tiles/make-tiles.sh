#!/bin/bash

TMP_DIR=.tmp/tiles
rm -rf $TMP_DIR

mkdir -p $TMP_DIR

COUNTRY_SHP=tiles/input/ne_10m_admin_0_countries_lakes/ne_10m_admin_0_countries_lakes.shp
ADM0_SHP=tiles/input/ICRC_Admin1_WD_Internal/ICRC_Admin1_WD_Internal.shp
SIMPLIFICATION=(5 10 50 100)
MIN_ZOOMS=(1 4 6 8)
MAX_ZOOMS=(3 5 7 12)

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
    -filter-fields ISO_A2,ADM0_A3_IS,NAME,ADM0_A3 \
    -o format=geojson $DIR/country.geojson

  node_modules/.bin/mapshaper $ADM0_SHP \
    -simplify visvalingam $PCT_SIMPLIFICATION% \
    -filter-islands min-vertices=2 remove-empty \
    -filter-fields ISO2,Admin00Nam,Admin01Nam,OBJECTID,Admin01Cod \
    -o format=geojson $DIR/adm1.geojson
done

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

  tippecanoe --projection EPSG:3857 \
    --named-layer=country:$SOURCE_DIR/country.geojson \
    --named-layer=adm1:$SOURCE_DIR/adm1.geojson \
    --read-parallel \
    --drop-rate=0 \
    --maximum-zoom=$MAX_ZOOM \
    --minimum-zoom=$MIN_ZOOM \
    --output $OUTPUT_DIR/tiles.mbtiles
done

tile-join -f -o $TMP_DIR/output/combined-go-tiles.mbtiles \
  $TMP_DIR/output/${SIMPLIFICATION[0]}/tiles.mbtiles \
  $TMP_DIR/output/${SIMPLIFICATION[1]}/tiles.mbtiles \
  $TMP_DIR/output/${SIMPLIFICATION[2]}/tiles.mbtiles \
  $TMP_DIR/output/${SIMPLIFICATION[3]}/tiles.mbtiles
