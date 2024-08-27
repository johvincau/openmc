#!/bin/bash
set -ex

# Upgrade pip, pytest, numpy before doing anything else.
pip install --upgrade pip
pip install --upgrade pytest
pip install --upgrade numpy

# Install NJOY 2016
if [[ ! -d "$HOME/NJOY2016" ]]; then
    ./tools/ci/gha-install-njoy.sh
fi
echo "$HOME/NJOY2016/bin" >> $GITHUB_PATH

# Install DAGMC if needed
if [[ $DAGMC = 'y' ]]; then
    if [ ! -d "$HOME/DAGMC" ] || [ ! -d "$HOME/MOAB" ]
    then
        ./tools/ci/gha-install-dagmc.sh
    fi
fi

# Install NCrystal if needed
if [[ $NCRYSTAL = 'y' ]]; then
    if [ ! -d "$HOME/ncrystal_bld" ]
    then
        ./tools/ci/gha-install-ncrystal.sh
    else
        cd $HOME/ncrystal_bld
        eval $( "$HOME/ncrystal_inst/bin/ncrystal-config" --setup )
        cd $GITHUB_WORKSPACE
    fi
fi

# Install vectfit for WMP generation if needed
if [[ $VECTFIT = 'y' ]]; then
    if [ ! -d "$HOME/vectfit" ]
    then
        ./tools/ci/gha-install-vectfit.sh
    fi
fi

# Install libMesh if needed
if [[ $LIBMESH = 'y' ]]; then
    if [ ! -d "$HOME/libmesh" ]
    then
        ./tools/ci/gha-install-libmesh.sh
    fi
fi

# Install MCPL
if [[ ! -d "$HOME/mcpl" ]]; then
    ./tools/ci/gha-install-mcpl.sh
fi


# For MPI configurations, make sure mpi4py and h5py are built against the
# correct version of MPI
if [[ $MPI == 'y' ]]; then
    pip install --no-binary=mpi4py mpi4py

    export CC=mpicc
    export HDF5_MPI=ON
    export HDF5_DIR=/usr/lib/x86_64-linux-gnu/hdf5/mpich
    pip install wheel "cython<3.0"
    pip install --no-binary=h5py --no-build-isolation h5py
fi

# Build and install OpenMC executable
python tools/ci/gha-install.py

# Install Python API in editable mode
pip install -e .[test,vtk,ci]
