# Welcome to the analysiskmeans Nextflow Pipeline! 
This README introduces you to the Nextflow Pipeline used to run analysiskmeans via Rapp! If you are looking for information on usage of the package itself, visit The R-Package's [README](https://github.com/nsmodi/analysiskmeans/blob/master/README.md)!

This branch was created for the purposes of using a NextFlow pipeline.

## Downloading Prerequisites 
The first step is to download necessary programs and software. Make sure you have a proper IDE to work with. In this project, I used VSCode. Learn more about setting up VSCode [Here](https://code.visualstudio.com/docs/setup/setup-overview).

If conda is not installed, please learn more about setting up conda [Here(https://docs.conda.io/projects/conda/en/stable/user-guide/install/index.html)!

## Conda Environment
In order to run our Nextflow pipeline, we want to create a specialized Nextflow Conda environment for that purpose. Run the lines below on your terminal to create such an environment.

```
conda create -n nextflow bioconda::nextflow # we want a separate env just for Nextflow
conda activate nextflow
```
After the environment is created, we activate it when we use Nextflow. 

## Docker Image 
To create the Docker Image, we can begin by making sure Docker is installed.
Run the following on your terminal to check installation:
```
docker --help
```
If this outputs a help message, with associated commands, that means that docker is indeed installed. If not, please refer to [the following](https://docs.docker.com/engine/install/) for help with docker installation!

In order to build and run the Dockerfile within this repository, there are a few simple steps to follow. 

We can start with the build. In order to build our Dockerfile, you can run the following line while being in the folder where the Dockerfile is. This part may take some time!

```
docker build -t analysiskmeans:0.0.2 .
```
In my package, Nextflow automatically runs the Dockerfile, so we don't have to run it separately. 

## Running Nextflow Workflow

To run the Nextflow Workflow, you first must get into the proper directory. 
If you are in the root of the repository, please get into the nextflow directory to begin.
```
cd nextflow 
```
Next, we can run nextflow by using the following command: 
```
nextflow run main.nf
```
This will run both your workflow processes at the same time, independently. In my first workflow process, I am running the elbow plot function from my R package in the CLI using Rapp. In my second workflow process, I am running the cluster plot function similarly so. 

The resulting plots will be saved in the results/ directory in the nextflow/ directory. 










