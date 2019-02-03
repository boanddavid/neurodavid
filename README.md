# Docker image for Computational Neuroimaging

A docker image for data analysis of neuroimaging such as DTI and Structural MRI. This build includes commonly used computational neuroimaging software such as freesurfer, fsl, as well as scientific libraries in Python and Matlab.

## Getting Started

### Prerequisites

You must have the latest docker installed. Download Docker from the [Official Docker Website](https://www.docker.com/products/docker-desktop).

### Installation 

The quickest method is to pull automatic builds of the images directly from Docker Hub and run it: 

```
docker run --rm --name neurodavid_session bowenwen/neurodavid:latest jupyter notebook
```

You must obtain your own license file (license.txt) from [freesurfer](https://surfer.nmr.mgh.harvard.edu/fswiki/License), then place it in `/opt/freesurfer-6.0.0/`. You may use the docker copy command to copy from host to container:

```
docker cp {host-pwd}license.txt neurodavid_session:/opt/freesurfer-6.0.0/foo.txt
```

To build the image yourself (example for Windows Powershell)

```
git clone https://github.com/bowenwen/neurodavid.git
Get-Content Dockerfile | docker build --tag neurodavid_test -
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
```
docker run --rm kaczmarj/neurodocker:0.4.3 generate docker --base=neurodebian:stretch --pkg-manager=apt --ndfreeze date=20181201 --freesurfer version=6.0.0 method=binaries --fsl version=5.0.11 method=binaries --dcm2niix version=latest method=source --ants version=2.3.1 method=binaries --spm12 version=r7219 method=binaries  --matlabmcr version=2018a method=binaries --miniconda create_env=neuro conda_install='python=3.6 numpy pandas traits matplotlib scikit-learn scikit-image seaborn nbformat nb_conda vtk' pip_install='nipype' --miniconda use_env=neuro conda_install='pytest jupyter jupyterlab jupyter_contrib_nbextensions' > Dockerfile

```

### Third-party Software Licenses

FreeSurfer is developed by the [Martinos Center for Biomedical Imaging at Massachusetts General Hospital] (https://surfer.nmr.mgh.harvard.edu/fswiki/FreeSurferSoftwareLicense) 

FSL is developed by the [University of Oxford](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/Licence).

Matlab runtime is included in this docker image and is made available by [MathWorks](https://www.mathworks.com/products/compiler/matlab-runtime.html).

## Future Dev

Resolve cmake version issue when adding `--ants version=latest method=source ` to initial build file.
