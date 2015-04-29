![stimulus-fig](https://raw.githubusercontent.com/HukLab/3d-integ/master/stimulus-fig.png)

## Overview

This is the repo used to generate figures in Matlab for the paper "A distinct mechanism of temporal integration for motion through depth". This repo uses data generated by another repo: [3d-integ-analysis](https://github.com/HukLab/3d-integ-analysis).

## Generating figures

### Requirements

To generate the data in `fits/` you will need to install the requirements of the analysis repo: [3d-integ-analysis](https://github.com/HukLab/3d-integ-analysis).

### Instructions

0. Clone this repo and the 3d-integ-analysis repo.
1. Install the Python requirements for 3d-integ-analysis.
2. Run `./3d-integ-analysis/bin/fig_data_gen.sh 3d-integ/fits` to generate fits. (This will take a while.)
3. In Matlab, run `3d-integ/bin/main.m`.

The resulting pdf figures should now be in `3d-integ/plots/`.

## Folder structure

* __bin/ (.m)__ - creates figures using data in fits/

* __fits/ (.csv)__ - data created by [3d-integ-analysis](https://github.com/HukLab/3d-integ-analysis)

* __plots/ (.pdf)__ - final figures created by bin/
