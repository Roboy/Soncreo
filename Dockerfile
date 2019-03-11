FROM missxa/bouncy-roboy
LABEL maintainer "NVIDIA CORPORATION <cudatools@nvidia.com>"

# CUDA 9.2 is not officially supported on ubuntu 18.04 yet, we use the ubuntu 17.10 repository for CUDA instead.
RUN apt-get update && apt-get install -y --no-install-recommends gnupg2 curl ca-certificates && \
    curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1710/x86_64/7fa2af80.pub | apt-key add - && \
    echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1710/x86_64 /" > /etc/apt/sources.list.d/cuda.list && \
    echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list && \
    apt-get purge --autoremove -y curl && \
    rm -rf /var/lib/apt/lists/*

ENV CUDA_VERSION 9.2.148

ENV CUDA_PKG_VERSION 9-2=$CUDA_VERSION-1
RUN apt-get update && apt-get install -y --no-install-recommends \
        cuda-cudart-$CUDA_PKG_VERSION && \
    ln -s cuda-9.2 /usr/local/cuda && \
    rm -rf /var/lib/apt/lists/*

# nvidia-docker 1.0
LABEL com.nvidia.volumes.needed="nvidia_driver"
LABEL com.nvidia.cuda.version="${CUDA_VERSION}"

RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
ENV NVIDIA_REQUIRE_CUDA "cuda>=9.2"

# Install Cuda Toolkit (NVCC) and Requirements for Soncreo
RUN apt-get update
RUN apt install -y nvidia-cuda-toolkit

## Copying Git Code from Soncreo
#RUN apt install git
#RUN git clone https://github.com/Roboy/soncreo.git
#RUN cd soncreo
#RUN git init
#RUN git submodule init
#RUN git submodule update
RUN alias python=python3
RUN pip3 install torch torchvision
RUN apt install -y libasound-dev portaudio19-dev libportaudio2 libportaudiocpp0 ffmpeg
#RUN pip3 install -r requirements.txt 
