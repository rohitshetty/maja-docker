FROM ubuntu:latest as maja-build 

RUN ln -fs /usr/share/zoneinfo/Europe/Amsterdam /etc/localtime 

RUN apt-get update && apt-get install -y \
  build-essential cmake pkg-config \ 
  cmake-curses-gui \ 
  git \ 
  tmux \ 
  software-properties-common \
  python \
  libffi-dev \
  mono-complete \
  bison flex \
  libpcre++-dev \
  wget \
  lsof \
  zip unzip curl \
  && dpkg-reconfigure -f noninteractive tzdata


#  We use this as the SRTM Dataset download link is broken in the released version but is fixed in develop 
# https://gitlab.orfeo-toolbox.org/maja/maja/-/issues/200
#  Probably will be fixed in 4.4.0
RUN git clone --single-branch --depth 1 https://gitlab.orfeo-toolbox.org/maja/maja.git --branch develop  /src/MAJA

WORKDIR /src/MAJA
RUN mkdir build && mkdir install && cd build \
  && cmake ../SuperBuild -DDOWNLOAD_DIR=../SuperBuild-archives/ -DENABLE_TU=OFF -DENABLE_TV=OFF -DENABLE_TVA=OFF -DCMAKE_INSTALL_PREFIX=`pwd`/../install && make -j4

# This fails, not sure why
# RUN cd build && make binpkg