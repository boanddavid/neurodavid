# Docker image for Computational Neuroimaging

A docker image for data analysis of neuroimaging such as DTI and Structural MRI. This build includes commonly used computational neuroimaging software such as freesurfer, fsl, as well as scientific libraries in Python and Matlab.

## Getting Started

### Prerequisites

You must have the latest docker installed. Download Docker from the [Official Docker Website](https://www.docker.com/products/docker-desktop).

### Installation 

The quickest method is to pull automatic builds of the images directly from Docker Hub and run it: 

``` bash
docker run --rm --name neurodavid_session -p 8888:8888 bowenwen/neurodavid:latest jupyter notebook --allow-root --ip=0.0.0.0 --port=8888 --no-browser --notebook-dir=/home/neuro
```

You can now access the docker container via `http://127.0.0.1:8888`

You must obtain your own license file (license.txt) from [freesurfer](https://surfer.nmr.mgh.harvard.edu/fswiki/License), then place it in container's `/opt/freesurfer-6.0.0/`. You may use the docker copy command to copy from host to container:

``` bash
cd {licensefile_pwd}
docker cp license.txt neurodavid_session:/opt/freesurfer-6.0.0/license.txt
```

To build the image yourself

``` bash
git clone https://github.com/bowenwen/neurodavid.git
cd neurodavid
# opt-1. building with Windows Powershell
Get-Content Dockerfile | docker build --tag neurodavid_test -
# opt-2. otherwise
docker build --tag neurodavid_test .
# opt-3. adding cache to make build faster
docker build --tag neurodavid_test --cache-from bowenwen/neurodavid .
Get-Content Dockerfile | docker build - --tag neurodavid_test --cache-from bowenwen/neurodavid
```

### Additional Options

If you wish to customize setting at the container level, you may want to customize the docker-compose file included in this repository.

#### Setting passwords for your Jupyter Notebook

You can generate your own password when you run your own container, follow the instruction [to prepare a hashed password](https://jupyter-notebook.readthedocs.io/en/stable/public_server.html#preparing-a-hashed-password)

#### Other versions

For more versions of this docker image build, check out this repo on DockerHub: [bowenwen/neurodavid](https://hub.docker.com/r/bowenwen/neurodavid)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

## Acknowledgments

This customized docker image was generated using [kaczmarj/neurodocker](https://github.com/kaczmarj/neurodocker/tree/master/examples) with some personalization. The initial commit of the Dockerfile was generated using the following command:

``` bash
docker run --rm kaczmarj/neurodocker:0.6.0 generate docker --base=neurodebian:stretch --pkg-manager=apt --ndfreeze date=20181201 --freesurfer version=6.0.0 method=binaries --fsl version=5.0.11 method=binaries --dcm2niix version=latest method=source --ants version=2.3.1 method=binaries --spm12 version=r7219 method=binaries  --matlabmcr version=2018a method=binaries --user neuro --miniconda create_env=neuro conda_install='python=3.6 pytest jupyter jupyterlab traits pandas matplotlib scikit-learn scikit-image seaborn nbformat nb_conda vtk' pip_install='nipype' --user=root --run 'echo \"deb http://http.debian.net/debian/ stretch main contrib non-free\" > /etc/apt/sources.list' --install sudo --install ttf-mscorefonts-installer --run-bash "cd /home/neuro && wget https://cmake.org/files/v3.13/cmake-3.13.4.tar.gz && tar xzf cmake-3.13.4.tar.gz && cd cmake-3.13.4 && ./configure --prefix=/opt/cmake-3.13.4 && make && make install && ln -s /opt/cmake-3.13.4/bin/* /usr/local/bin && cd /home/neuro && rm -f /home/neuro/cmake-3.13.4.tar.gz && rm -rf /home/neuro/cmake-3.13.4" --user neuro --miniconda use_env=neuro conda_install='jupyter_contrib_nbextensions nodejs' pip_install='nbdime ipympl jupyterlab_latex' activate=true --run-bash 'source activate neuro && jupyter nbextension enable exercise2/main && jupyter nbextension enable spellchecker/main && jupyter labextension install @jupyterlab/git && jupyter serverextension enable --py jupyterlab_git && jupyter labextension install @jupyter-widgets/jupyterlab-manager && jupyter labextension install jupyter-matplotlib && jupyter serverextension enable --sys-prefix jupyterlab_latex && jupyter labextension install @jupyterlab/latex && jupyter labextension install jupyterlab_bokeh' --miniconda use_env=neuro pip_install='yapf xlrd' activate=true --user=root --workdir /home/neuro --cmd jupyter-notebook > Dockerfile
```

If you are are generating the Dockerfile in Windows, make sure the export file encoding is UTF-8, or else DockerHub won't be able to read it.

### Third-party Software Licenses

FreeSurfer is developed by the [Martinos Center for Biomedical Imaging at Massachusetts General Hospital](https://surfer.nmr.mgh.harvard.edu/fswiki/FreeSurferSoftwareLicense) 

FSL is developed by the [University of Oxford](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/Licence).

Matlab runtime is included in this docker image and is made available by [MathWorks](https://www.mathworks.com/products/compiler/matlab-runtime.html).

## Future Dev

Resolve cmake version issue when adding `--ants version=latest method=source ` to initial build file.
