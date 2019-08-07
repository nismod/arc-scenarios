#
# Run all steps in scenarios workflow
#
# e.g. usage:
#     bash -e -x run.sh ~/OneDrive\ -\ Nexus365/ARC/ 2.0.0-rc1
#
SHARED_FOLDER=$1
VERSION=$2

# Dwellings
jupyter nbconvert --execute --no-prompt ./arc-dwellings/convert-scenarios.ipynb
# copy to shared folder
cp -r ./arc-dwellings/data_processed "$SHARED_FOLDER/Scenarios/Dwellings/"
# copy to simim
cp ./arc-dwellings/data_processed/*.csv ./simim/data/arc/

# Economics
jupyter nbconvert --ExecutePreprocessor.timeout=600 --execute --no-prompt ./arc-economics/convert-scenarios.ipynb
# copy to shared folder
cp -r ./arc-economics/data_processed "$SHARED_FOLDER/Scenarios/Economics/"
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
cp ./simim/data/output/arc*.csv "$SHARED_FOLDER/Scenarios/Population/data/output"

# Per-capita economics
cp ./simim/data/output/arc*.csv ./arc-economics/data_as_provided/
python ./arc-economics/post-population.py ./arc-economics

# Floor area
cp ./arc-dwellings/data_processed/*.csv ./arc-floor-area/data_as_provided
cp ./arc-economics/data_processed/*.csv ./arc-floor-area/data_as_provided
python ./arc-floor-area/estimate-floor-area.py ./arc-floor-area

# Package for smif
# TODO: combine in folder, use version, zip
