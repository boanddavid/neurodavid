# Your version: 0.6.0 Latest version: 0.6.0
# Generated by Neurodocker version 0.6.0
# Timestamp: 2020-02-19 02:49:03 UTC
# 
# Thank you for using Neurodocker. If you discover any issues
# or ways to improve this software, please submit an issue or
# pull request on our GitHub repository:
# 
#     https://github.com/kaczmarj/neurodocker

FROM neurodebian:stretch

ARG DEBIAN_FRONTEND="noninteractive"

RUN apt-get update -qq \
    && apt-get install -y -q --no-install-recommends neurodebian-freeze \
    && nd_freeze  20181201 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV LANG="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    ND_ENTRYPOINT="/neurodocker/startup.sh"
RUN export ND_ENTRYPOINT="/neurodocker/startup.sh" \
    && apt-get update -qq \
    && apt-get install -y -q --no-install-recommends \
           apt-utils \
           bzip2 \
           ca-certificates \
           curl \
           locales \
           unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && update-locale LANG="en_US.UTF-8" \
    && chmod 777 /opt && chmod a+s /opt \
    && mkdir -p /neurodocker \
    && if [ ! -f "$ND_ENTRYPOINT" ]; then \
         echo '#!/usr/bin/env bash' >> "$ND_ENTRYPOINT" \
    &&   echo 'set -e' >> "$ND_ENTRYPOINT" \
    &&   echo 'export USER="${USER:=`whoami`}"' >> "$ND_ENTRYPOINT" \
    &&   echo 'if [ -n "$1" ]; then "$@"; else /usr/bin/env bash; fi' >> "$ND_ENTRYPOINT"; \
    fi \
    && chmod -R 777 /neurodocker && chmod a+s /neurodocker

ENTRYPOINT ["/neurodocker/startup.sh"]

ENV FREESURFER_HOME="/opt/freesurfer-dev-20200218" \
    PATH="/opt/freesurfer-dev-20200218/bin:$PATH"
RUN apt-get update -qq \
    && apt-get install -y -q --no-install-recommends \
           bc \
           libgomp1 \
           libxmu6 \
           libxt6 \
           perl \
           tcsh \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && echo "Downloading FreeSurfer ..." \
    && mkdir -p /opt/freesurfer-dev-20200218 \
    && curl -fsSL --retry 5 ftp://surfer.nmr.mgh.harvard.edu/pub/dist/freesurfer/dev/freesurfer-linux-centos6_x86_64-dev.tar.gz \
    | tar -xz -C /opt/freesurfer-dev-20200218 --strip-components 1 \
         --exclude='freesurfer/average/mult-comp-cor' \
         --exclude='freesurfer/lib/cuda' \
         --exclude='freesurfer/lib/qt' \
         --exclude='freesurfer/subjects/V1_average' \
         --exclude='freesurfer/subjects/bert' \
         --exclude='freesurfer/subjects/cvs_avg35' \
         --exclude='freesurfer/subjects/cvs_avg35_inMNI152' \
         --exclude='freesurfer/subjects/fsaverage3' \
         --exclude='freesurfer/subjects/fsaverage4' \
         --exclude='freesurfer/subjects/fsaverage5' \
         --exclude='freesurfer/subjects/fsaverage6' \
         --exclude='freesurfer/subjects/fsaverage_sym' \
         --exclude='freesurfer/trctrain' \
    && sed -i '$isource "/opt/freesurfer-dev-20200218/SetUpFreeSurfer.sh"' "$ND_ENTRYPOINT"

ENV FSLDIR="/opt/fsl-5.0.11" \
    PATH="/opt/fsl-5.0.11/bin:$PATH"
RUN apt-get update -qq \
    && apt-get install -y -q --no-install-recommends \
           bc \
           dc \
           file \
           libfontconfig1 \
           libfreetype6 \
           libgl1-mesa-dev \
           libgl1-mesa-dri \
           libglu1-mesa-dev \
           libgomp1 \
           libice6 \
           libxcursor1 \
           libxft2 \
           libxinerama1 \
           libxrandr2 \
           libxrender1 \
           libxt6 \
           sudo \
           wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && echo "Downloading FSL ..." \
    && mkdir -p /opt/fsl-5.0.11 \
    && curl -fsSL --retry 5 https://fsl.fmrib.ox.ac.uk/fsldownloads/fsl-5.0.11-centos6_64.tar.gz \
    | tar -xz -C /opt/fsl-5.0.11 --strip-components 1 \
    && sed -i '$iecho Some packages in this Docker container are non-free' $ND_ENTRYPOINT \
    && sed -i '$iecho If you are considering commercial use of this container, please consult the relevant license:' $ND_ENTRYPOINT \
    && sed -i '$iecho https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/Licence' $ND_ENTRYPOINT \
    && sed -i '$isource $FSLDIR/etc/fslconf/fsl.sh' $ND_ENTRYPOINT \
    && echo "Installing FSL conda environment ..." \
    && bash /opt/fsl-5.0.11/etc/fslconf/fslpython_install.sh -f /opt/fsl-5.0.11

ENV PATH="/opt/dcm2niix-latest/bin:$PATH"
RUN apt-get update -qq \
    && apt-get install -y -q --no-install-recommends \
           cmake \
           g++ \
           gcc \
           git \
           make \
           pigz \
           zlib1g-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && git clone https://github.com/rordenlab/dcm2niix /tmp/dcm2niix \
    && mkdir /tmp/dcm2niix/build \
    && cd /tmp/dcm2niix/build \
    && cmake  -DCMAKE_INSTALL_PREFIX:PATH=/opt/dcm2niix-latest .. \
    && make \
    && make install \
    && rm -rf /tmp/dcm2niix

ENV ANTSPATH="/opt/ants-2.3.1" \
    PATH="/opt/ants-2.3.1:$PATH"
RUN echo "Downloading ANTs ..." \
    && mkdir -p /opt/ants-2.3.1 \
    && curl -fsSL --retry 5 https://dl.dropbox.com/s/1xfhydsf4t4qoxg/ants-Linux-centos6_x86_64-v2.3.1.tar.gz \
    | tar -xz -C /opt/ants-2.3.1 --strip-components 1

ENV FORCE_SPMMCR="1" \
    LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/lib/x86_64-linux-gnu:/opt/matlabmcr-2010a/v713/runtime/glnxa64:/opt/matlabmcr-2010a/v713/bin/glnxa64:/opt/matlabmcr-2010a/v713/sys/os/glnxa64:/opt/matlabmcr-2010a/v713/extern/bin/glnxa64" \
    MATLABCMD="/opt/matlabmcr-2010a/v713/toolbox/matlab"
RUN export TMPDIR="$(mktemp -d)" \
    && apt-get update -qq \
    && apt-get install -y -q --no-install-recommends \
           bc \
           libncurses5 \
           libxext6 \
           libxmu6 \
           libxpm-dev \
           libxt6 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && echo "Downloading MATLAB Compiler Runtime ..." \
    && curl -sSL --retry 5 -o /tmp/toinstall.deb http://mirrors.kernel.org/debian/pool/main/libx/libxp/libxp6_1.0.2-2_amd64.deb \
    && dpkg -i /tmp/toinstall.deb \
    && rm /tmp/toinstall.deb \
    && apt-get install -f \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && curl -fsSL --retry 5 -o "$TMPDIR/MCRInstaller.bin" https://dl.dropbox.com/s/zz6me0c3v4yq5fd/MCR_R2010a_glnxa64_installer.bin \
    && chmod +x "$TMPDIR/MCRInstaller.bin" \
    && "$TMPDIR/MCRInstaller.bin" -silent -P installLocation="/opt/matlabmcr-2010a" \
    && rm -rf "$TMPDIR" \
    && unset TMPDIR \
    && echo "Downloading standalone SPM ..." \
    && curl -fsSL --retry 5 -o /tmp/spm12.zip https://www.fil.ion.ucl.ac.uk/spm/download/restricted/utopia/previous/spm12_r7219_R2010a.zip \
    && unzip -q /tmp/spm12.zip -d /tmp \
    && mkdir -p /opt/spm12-r7219 \
    && mv /tmp/spm12/* /opt/spm12-r7219/ \
    && chmod -R 777 /opt/spm12-r7219 \
    && rm -rf /tmp/spm* \
    && /opt/spm12-r7219/run_spm12.sh /opt/matlabmcr-2010a/v713 quit \
    && sed -i '$iexport SPMMCRCMD=\"/opt/spm12-r7219/run_spm12.sh /opt/matlabmcr-2010a/v713 script\"' $ND_ENTRYPOINT

ENV LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/lib/x86_64-linux-gnu:/opt/matlabmcr-2018a/v94/runtime/glnxa64:/opt/matlabmcr-2018a/v94/bin/glnxa64:/opt/matlabmcr-2018a/v94/sys/os/glnxa64:/opt/matlabmcr-2018a/v94/extern/bin/glnxa64" \
    MATLABCMD="/opt/matlabmcr-2018a/v94/toolbox/matlab"
RUN export TMPDIR="$(mktemp -d)" \
    && apt-get update -qq \
    && apt-get install -y -q --no-install-recommends \
           bc \
           libncurses5 \
           libxext6 \
           libxmu6 \
           libxpm-dev \
           libxt6 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && echo "Downloading MATLAB Compiler Runtime ..." \
    && curl -fsSL --retry 5 -o "$TMPDIR/mcr.zip" https://ssd.mathworks.com/supportfiles/downloads/R2018a/deployment_files/R2018a/installers/glnxa64/MCR_R2018a_glnxa64_installer.zip \
    && unzip -q "$TMPDIR/mcr.zip" -d "$TMPDIR/mcrtmp" \
    && "$TMPDIR/mcrtmp/install" -destinationFolder /opt/matlabmcr-2018a -mode silent -agreeToLicense yes \
    && rm -rf "$TMPDIR" \
    && unset TMPDIR

RUN test "$(getent passwd neuro)" || useradd --no-user-group --create-home --shell /bin/bash neuro
USER neuro

ENV CONDA_DIR="/opt/miniconda-latest" \
    PATH="/opt/miniconda-latest/bin:$PATH"
RUN export PATH="/opt/miniconda-latest/bin:$PATH" \
    && echo "Downloading Miniconda installer ..." \
    && conda_installer="/tmp/miniconda.sh" \
    && curl -fsSL --retry 5 -o "$conda_installer" https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && bash "$conda_installer" -b -p /opt/miniconda-latest \
    && rm -f "$conda_installer" \
    && conda update -yq -nbase conda \
    && conda config --system --prepend channels conda-forge \
    && conda config --system --set auto_update_conda false \
    && conda config --system --set show_channel_urls true \
    && sync && conda clean --all && sync \
    && conda create -y -q --name neuro \
    && conda install -y -q --name neuro \
           "python=3.6" \
           "pytest" \
           "jupyter" \
           "jupyterlab" \
           "traits" \
           "pandas" \
           "matplotlib" \
           "scikit-learn" \
           "scikit-image" \
           "seaborn" \
           "nbformat" \
           "nb_conda" \
           "vtk" \
    && sync && conda clean --all && sync \
    && bash -c "source activate neuro \
    &&   pip install --no-cache-dir  \
             "nipype"" \
    && rm -rf ~/.cache/pip/* \
    && sync

USER root

RUN echo "deb http://http.debian.net/debian/ stretch main contrib non-free" > /etc/apt/sources.list

RUN apt-get update -qq \
    && apt-get install -y -q --no-install-recommends \
           sudo \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update -qq \
    && apt-get install -y -q --no-install-recommends \
           ttf-mscorefonts-installer \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN bash -c 'cd /home/neuro && wget https://cmake.org/files/v3.13/cmake-3.13.4.tar.gz && tar xzf cmake-3.13.4.tar.gz && cd cmake-3.13.4 && ./configure --prefix=/opt/cmake-3.13.4 && make && make install && ln -s /opt/cmake-3.13.4/bin/* /usr/local/bin && cd /home/neuro && rm -f /home/neuro/cmake-3.13.4.tar.gz && rm -rf /home/neuro/cmake-3.13.4'

USER neuro

RUN conda install -y -q --name neuro \
           "jupyter_contrib_nbextensions" \
           "nodejs" \
    && sync && conda clean --all && sync \
    && bash -c "source activate neuro \
    &&   pip install --no-cache-dir  \
             "nbdime" \
             "ipympl" \
             "jupyterlab_latex"" \
    && rm -rf ~/.cache/pip/* \
    && sync \
    && sed -i '$isource activate neuro' $ND_ENTRYPOINT

RUN bash -c 'source activate neuro && jupyter nbextension enable exercise2/main && jupyter nbextension enable spellchecker/main'

RUN bash -c "source activate neuro \
    &&   pip install --no-cache-dir  \
             "yapf" \
             "xlrd"" \
    && rm -rf ~/.cache/pip/* \
    && sync \
    && sed -i '$isource activate neuro' $ND_ENTRYPOINT

USER root

WORKDIR /home/neuro

CMD ["jupyter-notebook"]

RUN echo '{ \
    \n  "pkg_manager": "apt", \
    \n  "instructions": [ \
    \n    [ \
    \n      "base", \
    \n      "neurodebian:stretch" \
    \n    ], \
    \n    [ \
    \n      "ndfreeze", \
    \n      { \
    \n        "date": "20181201" \
    \n      } \
    \n    ], \
    \n    [ \
    \n      "freesurfer", \
    \n      { \
    \n        "version": "dev-20200218", \
    \n        "method": "binaries" \
    \n      } \
    \n    ], \
    \n    [ \
    \n      "fsl", \
    \n      { \
    \n        "version": "5.0.11", \
    \n        "method": "binaries" \
    \n      } \
    \n    ], \
    \n    [ \
    \n      "dcm2niix", \
    \n      { \
    \n        "version": "latest", \
    \n        "method": "source" \
    \n      } \
    \n    ], \
    \n    [ \
    \n      "ants", \
    \n      { \
    \n        "version": "2.3.1", \
    \n        "method": "binaries" \
    \n      } \
    \n    ], \
    \n    [ \
    \n      "spm12", \
    \n      { \
    \n        "version": "r7219", \
    \n        "method": "binaries" \
    \n      } \
    \n    ], \
    \n    [ \
    \n      "matlabmcr", \
    \n      { \
    \n        "version": "2018a", \
    \n        "method": "binaries" \
    \n      } \
    \n    ], \
    \n    [ \
    \n      "user", \
    \n      "neuro" \
    \n    ], \
    \n    [ \
    \n      "miniconda", \
    \n      { \
    \n        "create_env": "neuro", \
    \n        "conda_install": [ \
    \n          "python=3.6", \
    \n          "pytest", \
    \n          "jupyter", \
    \n          "jupyterlab", \
    \n          "traits", \
    \n          "pandas", \
    \n          "matplotlib", \
    \n          "scikit-learn", \
    \n          "scikit-image", \
    \n          "seaborn", \
    \n          "nbformat", \
    \n          "nb_conda", \
    \n          "vtk" \
    \n        ], \
    \n        "pip_install": [ \
    \n          "nipype" \
    \n        ] \
    \n      } \
    \n    ], \
    \n    [ \
    \n      "user", \
    \n      "root" \
    \n    ], \
    \n    [ \
    \n      "run", \
    \n      "echo \"deb http://http.debian.net/debian/ stretch main contrib non-free\" > /etc/apt/sources.list" \
    \n    ], \
    \n    [ \
    \n      "install", \
    \n      [ \
    \n        "sudo" \
    \n      ] \
    \n    ], \
    \n    [ \
    \n      "install", \
    \n      [ \
    \n        "ttf-mscorefonts-installer" \
    \n      ] \
    \n    ], \
    \n    [ \
    \n      "run_bash", \
    \n      "cd /home/neuro && wget https://cmake.org/files/v3.13/cmake-3.13.4.tar.gz && tar xzf cmake-3.13.4.tar.gz && cd cmake-3.13.4 && ./configure --prefix=/opt/cmake-3.13.4 && make && make install && ln -s /opt/cmake-3.13.4/bin/* /usr/local/bin && cd /home/neuro && rm -f /home/neuro/cmake-3.13.4.tar.gz && rm -rf /home/neuro/cmake-3.13.4" \
    \n    ], \
    \n    [ \
    \n      "user", \
    \n      "neuro" \
    \n    ], \
    \n    [ \
    \n      "miniconda", \
    \n      { \
    \n        "use_env": "neuro", \
    \n        "conda_install": [ \
    \n          "jupyter_contrib_nbextensions", \
    \n          "nodejs" \
    \n        ], \
    \n        "pip_install": [ \
    \n          "nbdime", \
    \n          "ipympl", \
    \n          "jupyterlab_latex" \
    \n        ], \
    \n        "activate": true \
    \n      } \
    \n    ], \
    \n    [ \
    \n      "run_bash", \
    \n      "source activate neuro && jupyter nbextension enable exercise2/main && jupyter nbextension enable spellchecker/main" \
    \n    ], \
    \n    [ \
    \n      "miniconda", \
    \n      { \
    \n        "use_env": "neuro", \
    \n        "pip_install": [ \
    \n          "yapf", \
    \n          "xlrd" \
    \n        ], \
    \n        "activate": true \
    \n      } \
    \n    ], \
    \n    [ \
    \n      "user", \
    \n      "root" \
    \n    ], \
    \n    [ \
    \n      "workdir", \
    \n      "/home/neuro" \
    \n    ], \
    \n    [ \
    \n      "cmd", \
    \n      [ \
    \n        "jupyter-notebook" \
    \n      ] \
    \n    ] \
    \n  ] \
    \n}' > /neurodocker/neurodocker_specs.json
