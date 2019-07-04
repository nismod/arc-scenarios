#
# Run all steps
#
SHARED_FOLDER=$1

echo $1

# Dwellings
jupyter nbconvert --execute --no-prompt ./arc-dwellings/convert-scenarios.ipynb
cp -r ./arc-dwellings/data_processed $SHARED_FOLDER/Scenarios/Dwellings/

# Economics
jupyter nbconvert --execute --no-prompt ./arc-economics/convert-scenarios.ipynb
cp -r ./arc-economics/data_processed $SHARED_FOLDER/Scenarios/Economics/

# Population
pushd ./simim
mkdir -p ../microsimulation/cache
python ./scripts/run.py -c ./config/camkox0he.json
python ./scripts/run.py -c ./config/camkox1he.json
python ./scripts/run.py -c ./config/camkox2he.json
python ./scripts/postprocess.py -c ./config/camkox0he.json
popd

# Per-capita economics
jupyter nbconvert --execute --no-prompt ./arc-economics/post-poulation.ipynb

# Floor area
jupyter nbconvert --execute --no-prompt ./arc-floor-area/estimate-floor-area.ipynb
