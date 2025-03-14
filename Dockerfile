# syntax=docker/dockerfile:1
FROM archlinux:base-20250302.0.316047

# Install dependencies
RUN pacman --noconfirm -Syy git base-devel python wget unzip pkgconf ocamlbuild cmake protobuf bc

# Set environment variable to make scripts non-interactive
ENV DEPLOY_ENV=docker

# Install app
COPY ODT_implementation/ /ODT_implementation

RUN source /etc/profile

WORKDIR /ODT_implementation/scripts

# Start ODT installation
RUN ./setup.sh

# To compile the dockerfile, run:
# docker build -t setup_complete

# If you are using the SGX out-of-tree driver, you can start the built image as
# docker run -it --device=/dev/isgx -v /var/run/aesmd/aesm.socket:/var/run/aesmd/aesm.socket setup_complete