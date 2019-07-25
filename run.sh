#
# Run all steps in scenarios workflow
#
# e.g. usage:
#     bash -e -x run.sh ~/OneDrive\ -\ Nexus365/ARC/
#
SHARED_FOLDER=$1

# # Dwellings
# jupyter nbconvert --execute --no-prompt ./arc-dwellings/convert-scenarios.ipynb
# # copy to shared folder
# cp -r ./arc-dwellings/data_processed "$SHARED_FOLDER/Scenarios/Dwellings/"
# # copy to simim
# cp ./arc-dwellings/data_processed/*.csv ./simim/data/arc/

# # Economics
# jupyter nbconvert --ExecutePreprocessor.timeout=600 --execute --no-prompt ./arc-economics/convert-scenarios.ipynb
# # copy to shared folder
# cp -r ./arc-economics/data_processed "$SHARED_FOLDER/Scenarios/Economics/"
# # copy to simim
# cp ./arc-economics/data_processed/*.csv ./simim/data/arc/

# Population
pushd ./simim
    mkdir -p ./data/cache
    python ./scripts/generate_econ_scenarios.py
    # # test
    # python ./scripts/run.py -c ./config/calibrate.json
    # python ./scripts/run.py -c ./config/gravity.json
    # python ./scripts/run.py -c ./config/production_j.json
    # python ./scripts/run.py -c ./config/test.json

    # households only
    # python ./scripts/run.py -c ./config/arc0-unplanned__h.json
    # python ./scripts/run.py -c ./config/arc1-new-cities__h.json
    # python ./scripts/run.py -c ./config/arc2-expansion__h.json
    # python ./scripts/run.py -c ./config/arc3-new-cities23__h.json
    # python ./scripts/run.py -c ./config/arc4-expansion23__h.json
    
    # # with jobs accessibility and scenario access
    python ./scripts/run.py -c ./config/arc0-unplanned__gjh-od1.json
    python ./scripts/run.py -c ./config/arc1-new-cities__gjh-od1.json
    python ./scripts/run.py -c ./config/arc2-expansion__gjh-od1.json
    # # python ./scripts/run.py -c ./config/arc3-new-cities23__gjh-od1.json
    # # python ./scripts/run.py -c ./config/arc4-expansion23__gjh-od1.json

    # # with jobs accessibility and baseline access
    # python ./scripts/run.py -c ./config/arc0-unplanned__gjh-odb.json
    # python ./scripts/run.py -c ./config/arc1-new-cities__gjh-odb.json
    # python ./scripts/run.py -c ./config/arc2-expansion__gjh-odb.json
    # # python ./scripts/run.py -c ./config/arc3-new-cities23__gjh-odb.json
    # # python ./scripts/run.py -c ./config/arc4-expansion23__gjh-odb.json

    # # with jobs, no access
    python ./scripts/run.py -c ./config/arc0-unplanned__gjh.json
    python ./scripts/run.py -c ./config/arc1-new-cities__gjh.json
    python ./scripts/run.py -c ./config/arc2-expansion__gjh.json
    # # python ./scripts/run.py -c ./config/arc3-new-cities23__gjh.json
    # # python ./scripts/run.py -c ./config/arc4-expansion23__gjh.json

    # run sensitivities around unplanned
    # python ./scripts/run.py -c ./config/arc0-unplanned__gj-noa.json
    # python ./scripts/run.py -c ./config/arc0-unplanned__gj.json
    # python ./scripts/run.py -c ./config/arc0-unplanned__g-noa.json
    # python ./scripts/run.py -c ./config/arc0-unplanned__g-a.json
    # python ./scripts/run.py -c ./config/arc0-unplanned__gjh.json
    # python ./scripts/run.py -c ./config/arc0-unplanned__gjx.json
    # python ./scripts/run.py -c ./config/arc0-unplanned__h.json
    # python ./scripts/run.py -c ./config/arc0-unplanned__j-ascen.json
    # python ./scripts/run.py -c ./config/arc0-unplanned__j-a.json
    # python ./scripts/run.py -c ./config/arc0-unplanned__j-noa.json

    # # postprocess
    # python ./scripts/postprocess.py -c ./config/arc0-unplanned__gjh.json
popd

# # copy to shared folder
# cp ./simim/data/output/arc*.csv "$SHARED_FOLDER/Scenarios/Population/data/output"
# # copy to economics
# cp ./simim/data/output/arc*.csv ./arc-economics/data_processed/

# # Per-capita economics
# jupyter nbconvert --execute --no-prompt ./arc-economics/post-population.ipynb

# # Floor area
# jupyter nbconvert --execute --no-prompt ./arc-floor-area/estimate-floor-area.ipynb
