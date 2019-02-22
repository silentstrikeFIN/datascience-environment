FROM jupyter/all-spark-notebook

LABEL maintainer="Nilesh Patil (@nilesh-patil)"

USER root

# pre-requisites

RUN apt-get -qq update && \
    apt-get -qq install -y --no-install-recommends \
    apt-utils \
    software-properties-common \
    fonts-dejavu \
    tzdata \
    gfortran \
    gcc && \
    apt-get clean && \
    add-apt-repository universe && \
    rm -rf /var/lib/apt/lists/*

USER $NB_UID

# Anaconda Python Environments

RUN conda create -n python36 python=3.6 anaconda

##################################
#### Add Packages to Base ########
##################################
RUN /bin/bash -c "source activate base && \
    conda install --quiet --yes -c anaconda numpy scipy scikit-learn scikit-image pandas tqdm ipykernel ; \
    conda install --quiet --yes -c anaconda tensorflow ; \
    conda install --quiet --yes -c pytorch pytorch-cpu torchvision-cpu ; \
    conda install --quiet --yes -c conda-forge openpyxl h5py matplotlib ; \
    conda upgrade --all -y ;\
    pip install opencv-python imgaug; \
    conda clean --all -y ; \
    python -m ipykernel install --user --name base --display-name 'Python 3(Base)' && \
    fix-permissions $CONDA_DIR /home/$NB_USER && \
    source deactivate && \
##################################
#### Add Packages to Python36#####
##################################
    source activate python36 && \
    conda install --quiet --yes -c anaconda numpy scipy scikit-learn scikit-image pandas tqdm ipykernel && \
    conda install --quiet --yes -c anaconda tensorflow ; \
    conda install --quiet --yes -c keras StrawberryFields ; \
    conda install --quiet --yes -c pytorch pytorch-cpu torchvision-cpu ; \
    conda install --quiet --yes -c conda-forge openpyxl h5py matplotlib ; \
    conda upgrade --all -y ;\
    pip install opencv-python imgaug; \
    conda clean --all -y ; \
    python -m ipykernel install --user --name python36 --display-name 'Python 3.6' && \
    source deactivate &&\
    mv $HOME/.local/share/jupyter/kernels/* $CONDA_DIR/share/jupyter/kernels/ && \
    chmod -R go+rx $CONDA_DIR/share/jupyter && \
    rm -rf $HOME/.local && \
    fix-permissions $CONDA_DIR /home/$NB_USER $CONDA_DIR/share/jupyter"


EXPOSE 8888 4040 8080 8081 7077
