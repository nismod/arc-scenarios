# Arc scenarios workflow

[![DOI](https://zenodo.org/badge/190181451.svg)](https://zenodo.org/badge/latestdoi/190181451)

Run scenario models and preprocess data for input to
[`nismod/nismod2`](https://github.com/nismod/nismod2) for study and analysis of the
Oxford-Cambridge Arc.

Summary report:

> Infrastructure Transitions Research Consortium (December 2019) 'A sustainable
Oxford-Cambridge corridor? Spatial analysis of options and futures for the Arc' Available
online: https://www.itrc.org.uk/wp-content/uploads/2019/11/arc-report-2019-V4.pdf

The scenario generation workflow consists of:
- [`arc-dwellings`](https://github.com/nismod/arc-dwellings) - dwelling count (housing)
  scenarios
- [`arc-economics`](https://github.com/nismod/arc-economics) - regional GVA and employment
  scenarios from Cambridge Econometrics
- [`simim`](https://github.com/nismod/simim) - variants on population projections, affected by
  employment and housing scenarios
- [`arc-floor-area`](https://github.com/nismod/arc-floor-area) - residential/non-residential
  floor area scenarios, driven by population and GVA scenarios
- (TODO) [`udm`](https://github.com/geospatialncl/urban_development_model) - urban development
  scenarios at hectare grid scale, driven by population and employment scenarios as well as
  other attractors and constraints

Also uses:
- [`ukpopulation`](https://github.com/nismod/ukpopulation) - ONS population projections
  (UK-wide)
- (TODO) [`ukweather`](https://github.com/nismod/ukweather) - Weather@Home gridded climate
  projections


## Setup and run

This project collects several models and pieces of data processing using [git
submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules).

To download all:

```bash
git clone --recurse-submodules https://github.com/nismod/arc-scenarios
```

If you just cloned the `arc-scenarios` repository and forgot `--recurse-submodules`, pull the
submodules in by running:

```bash
git submodule update --init
```

### Python and libraries

This project uses Python 3. We suggest using [miniconda](https://conda.io/miniconda.html) to
set up an environment and manage library dependencies.

Create a conda environment from the `.environment.yml` definition (run once to install):

    conda env create -f .environment.yml

Activate the conda environment (run each time you want to work on arc-scenarios):

    conda activate arc-scenarios

Set up simim in develop mode:

    cd simim
    python setup.py develop

Set `nbstripout` to avoid committing data and figures in notebooks (may need to run in
submodules as well as top-level project):

    nbstripout --install

On windows, if you see `ModuleNotFoundError: No module named 'win32api'` then

    pip install pywin32


### Run

Run all:

    bash run.sh ./results v1.0.1

Run individual notebooks, for further data exploration or development, e.g.:

    cd ./arc-dwellings
    jupyter convert-scenarios.ipynb

Possible issues:

- 2016-based national population projections (from NOMIS, table `NM_2009_1`)
  might fail to download to
  `simim/data/cache/NM_2009_1_b0ba853c8043261df86d911ba0505793.tsv`
- Stats Wales subnational population projections (dataset `popu5099`) might fail
  to download to `simim/data/cache/snpp_w.csv`
- simim can fail with
  `Exception: one or more input arrays have missing/NaN values`: seems to be a
  first-run issue, tends to work after the second run


## Acknowledgments

This workflow was written and developed at the [Environmental Change Institute, University of
Oxford](http://www.eci.ox.ac.uk/) within the EPSRC sponsored MISTRAL programme, as part of the
[Infrastructure Transition Research Consortium](http://www.itrc.org.uk/).
