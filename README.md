## Overview

This is the repo used for generating figures in Matlab. Code for analyzing the experimental data behind the figures was done in Python and lives in a separate repo: data analysis: [3d-integ-analysis](https://github.com/HukLab/3d-integ-analysis).

## Generating figures

### Requirements

To generate figures from the paper you will need to install the python dependencies listed in `3d-integ-analysis/requirements.txt`.
Psignifit, which fits psychometric functions using Bayesian inference, is easiest to install on Ubuntu. Follow the instructions [here](http://neuro.debian.net/install_pkg.html?p=python-pypsignifit) to install Psignifit using neuro-debian. (Coincidentally, this will install all the other required packages as well!)

### Instructions

0. Clone this repo and the 3d-integ-analysis repo.
1. Run `3d-integ-analysis/bin/fig_data_gen.sh 3d-integ/fits` to generate fits. (This will take a while.)
2. In Matlab, run `3d-integ/bin/main.m`.

The resulting pdf figures should now be in `3d-integ/plots/`.

![stimulus-fig](https://github.com/HukLab/3d-integ/blob/master/stimulus-fig.png)

## Folder structure

* __bin/ (.m)__ - creates figures using data in fits/

* __fits/ (.csv)__ - data created by data analysis [3d-integ-analysis](https://github.com/HukLab/3d-integ-analysis)

* __plots/ (.pdf)__ - final figures created by bin/
