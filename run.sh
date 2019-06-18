#
# Run all steps
#


# Dwellings
jupyter nbconvert --execute --no-prompt arc-dwellings/convert-scenarios.ipynb

# Economics
jupyter nbconvert --execute --no-prompt arc-economics/convert-scenarios.ipynb

# Population
pushd ./simim
mkdir -p ../microsimulation/cache
python ./scripts/run.py -c ./config/camkox0he.json
python ./scripts/run.py -c ./config/camkox1he.json
python ./scripts/run.py -c ./config/camkox2he.json
python ./scripts/postprocess.py -c ./config/camkox0he.json
popd

# Per-capita economics
jupyter nbconvert --execute --no-prompt arc-economics/post-poulation.ipynb

# Floor area
jupyter nbconvert --execute --no-prompt arc-floor-area/estimate-floor-area.ipynb
