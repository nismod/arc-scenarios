# Arc scenarios workflow

Run scenario models and preprocess data for input to
[`nismod/nismod2`](https://github.com/nismod/nismod2).

Consists of:
- [`arc-dwellings`](https://github.com/nismod/arc-dwellings) - dwelling count projections
- [`arc-economics`](https://github.com/nismod/arc-economics) - regional GVA and employment
  projections
- [`arc-floor-area`](https://github.com/nismod/arc-floor-area) - residential/non-residential
  floor area projections
- [`simim`](https://github.com/nismod/simim) - variants on population projections, affected by
  employment scenarios

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


### Run

Run all:

    bash run.sh

Run individual notebooks, for further data exploration or development, e.g.:

    cd ./arc-dwellings
    jupyter convert-scenarios.ipynb


## Acknowledgments

This workflow was written and developed at the [Environmental Change Institute, University of
Oxford](http://www.eci.ox.ac.uk/) within the EPSRC sponsored MISTRAL programme, as part of the
[Infrastructure Transition Research Consortium](http://www.itrc.org.uk/).
