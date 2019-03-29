# Initial variables
ARG UBUNTU_VERSION=18.04
# Nvidia CUDA and Deep Neuronal Networks libraries
FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu${UBUNTU_VERSION} as base
ENV LANG C.UTF-8


RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    python3.7-dev python3-pip git g++ wget make libprotobuf-dev protobuf-compiler libopencv-dev \
    libgoogle-glog-dev libboost-all-dev libcaffe-cuda-dev libhdf5-dev libatlas-base-dev liblapacke-dev nano

# Numpy stack and opencv for python
RUN pip3 install numpy opencv-python

# X Server
RUN apt-get update && apt-get install -y x11-xserver-utils

# Cmake 3.14 release version
RUN wget https://github.com/Kitware/CMake/releases/download/v3.14.0/cmake-3.14.0-Linux-x86_64.tar.gz && \
    tar xzf cmake-3.14.0-Linux-x86_64.tar.gz -C /opt && \
    rm cmake-3.14.0-Linux-x86_64.tar.gz
ENV PATH="/opt/cmake-3.14.0-Linux-x86_64/bin:${PATH}"

ARG USER_ID=1000
ARG GROUP_ID=1000

RUN groupadd -g ${GROUP_ID} sim && \
    useradd -m -l -u ${USER_ID} -g sim sim && \
    echo "sim:sim" | chpasswd && adduser sim sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

ENV HOME /home/sim
ENV SIM_ROOT=$HOME

# Added to video group
RUN usermod -a -G video sim

USER sim

# ======================OpenPose===========================
WORKDIR $HOME
# RUN git clone --recurse-submodules https://github.com/kevinrev26/openpose.git
# COPY openpose openpose

# # RUN chmod -R 700 $HOME/openpose

# # RUN mkdir -p $HOME/openpose/build


# WORKDIR $HOME/openpose/build
# USER root
# RUN chmod -R 777 $HOME/openpose
# USER sim
# # Building OpenPose
# # 
# RUN cmake -DBUILD_PYTHON=ON .. && make -j`nproc`

WORKDIR $HOME/openpose