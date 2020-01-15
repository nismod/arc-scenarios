#
# Run all steps in scenarios workflow
#
# e.g. usage:
#     bash run.sh ~/OneDrive\ -\ Nexus365/ARC/Scenarios 1.0.1
#

# echo commands and quit at first error
set -e
set -x

SHARED_FOLDER=$1
VERSION=$2

# Dwellings
jupyter nbconvert --ExecutePreprocessor.timeout=-1 --execute --no-prompt ./arc-dwellings/convert-scenarios.ipynb
# copy to shared folder
cp -r ./arc-dwellings/data_processed "$SHARED_FOLDER/Dwellings/"
# copy to simim
cp ./arc-dwellings/data_processed/*.csv ./simim/data/arc/

# Economics
jupyter nbconvert --ExecutePreprocessor.timeout=-1 --execute --no-prompt ./arc-economics/convert-scenarios.ipynb
# copy to shared folder
cp -r ./arc-economics/data_processed "$SHARED_FOLDER/Economics/"
# copy to simim
cp ./arc-economics/data_processed/*.csv ./simim/data/arc/

# Population
pushd ./simim
    mkdir -p ./data/cache
    python ./scripts/generate_econ_scenarios.py

    # with jobs accessibility and scenario access
    python ./scripts/run.py -c ./config/arc0-unplanned__gjh-od1.json
    python ./scripts/run.py -c ./config/arc1-new-cities__gjh-od1.json
    python ./scripts/run.py -c ./config/arc2-expansion__gjh-od1.json
    python ./scripts/run.py -c ./config/arc3-new-cities23__gjh-od1.json
    python ./scripts/run.py -c ./config/arc4-expansion23__gjh-od1.json

    # postprocess to scale and smif-format
    python ./scripts/postprocess.py -c ./config/arc0-unplanned__gjh-od1.json
popd

# copy to shared folder
cp ./simim/data/output/arc*.csv "$SHARED_FOLDER/Population/data/output"

# Per-capita economics
cp ./simim/data/output/arc*.csv ./arc-economics/data_as_provided/
python ./arc-economics/post-population.py ./arc-economics

# Floor area
cp ./arc-dwellings/data_processed/*.csv ./arc-floor-area/data_as_provided
cp ./arc-economics/data_processed/*.csv ./arc-floor-area/data_as_provided
python ./arc-floor-area/estimate-floor-area.py ./arc-floor-area

# Package for smif
DIRNAME="socio-economic-$VERSION"
rm -rf $DIRNAME
rm -f "$DIRNAME.zip"
mkdir $DIRNAME

cp ./arc-dwellings/data_processed/arc_dwellings__*.csv $DIRNAME

cp ./arc-economics/data_processed/arc_employment__*.csv $DIRNAME
cp ./arc-economics/data_processed/arc_employment_by_sector__*.csv $DIRNAME
cp ./arc-economics/data_processed/arc_employment_by_sector_for_energy_demand__*.csv $DIRNAME
cp ./arc-economics/data_processed/arc_gva__*.csv $DIRNAME
cp ./arc-economics/data_processed/arc_gva_by_sector__*.csv $DIRNAME
cp ./arc-economics/data_processed/arc_gva_by_sector_for_energy_demand__*.csv $DIRNAME
cp ./arc-economics/data_processed/arc_gva_per_head__*.csv $DIRNAME

cp ./simim/data/output/arc_population__*.csv $DIRNAME

cp ./arc-floor-area/data_processed/arc_floor_area__*.csv $DIRNAME

# drop new-cities in favour of new-cites-with-dwellings variants
rm $DIRNAME/arc_population__1-new-cities.csv
rm $DIRNAME/arc_population__3-new-cities23.csv
rm $DIRNAME/arc_gva_per_head__1-new-cities.csv
rm $DIRNAME/arc_gva_per_head__3-new-cities23.csv
# drop -nb (no-base-change) variants
rm $DIRNAME/*-nb.csv

zip -r "$DIRNAME.zip" $DIRNAME

# Copy to share
# cp "$DIRNAME.zip" "$SHARED_FOLDER/$DIRNAME.zip"
# aws s3 cp "$DIRNAME.zip" "s3://nismod2-data/scenarios/$DIRNAME.zip"
