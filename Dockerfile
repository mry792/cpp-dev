ARG GCC_VER
ARG CONAN_VER
ARG BROKKR_VER

###
# STAGE: base
###

FROM gcc:${GCC_VER} AS base

RUN apt update && \
    apt install --yes --no-install-recommends \
        cmake \
        curl \
        grep \
        less \
        lsb-release \
        pipx \
        sudo \
        tree \
        vim \
      && \
    rm --recursive --force /var/lib/apt/lists/*

###
# STAGE: ci-build
###

FROM base AS ci-build

# Setup Conan.
ARG CONAN_VER
ARG BROKKR_VER
ARG CONAN_EXE=/root/.local/bin/conan
RUN pipx install conan==${CONAN_VER} && \
    pipx ensurepath && \
    rm --recursive --force /root/.cache
RUN ${CONAN_EXE} config install https://github.com/mry792/conan-config.git
RUN wget \
        https://github.com/mry792/brokkr/archive/refs/tags/v${BROKKR_VER}.tar.gz \
        --output-document - | \
        tar -xzf - && \
    ${CONAN_EXE} create brokkr-${BROKKR_VER} --version ${BROKKR_VER} --user egoss --channel stable && \
    ${CONAN_EXE} cache clean -vdebug --source --build --download --temp "brokkr/${BROKKR_VER}@egoss/stable"


###
# STAGE: develop
###

FROM base AS develop

# Setup local user.
ARG DOCKER_USER
ARG DOCKER_UID
ARG DOCKER_GID
RUN groupadd --gid ${DOCKER_GID} ${DOCKER_USER} && \
    useradd \
        --shell /bin/bash \
        --create-home \
        --uid ${DOCKER_UID} \
        --gid ${DOCKER_GID} \
        ${DOCKER_USER} && \
    echo "${DOCKER_USER} ALL=NOPASSWD: ALL" \
        > /etc/sudoers.d/devsudo
USER ${DOCKER_USER}
WORKDIR ${HOME}
COPY bashrc /home/${DOCKER_USER}/.bashrc
COPY bash_profile /home/${DOCKER_USER}/.bash_profile
COPY gitconfig /home/${DOCKER_USER}/.gitconfig

# Setup Conan.
ARG CONAN_VER
ARG CONAN_EXE=/home/${DOCKER_USER}/.local/bin/conan
RUN pipx install conan==${CONAN_VER} && \
    rm --recursive --force /home/${DOCKER_USER}/.cache
COPY \
    --from=ci-build \
    --chown=${DOCKER_UID}:${DOCKER_GID} \
    /root/.conan2 \
    /home/${DOCKER_USER}/.conan2

CMD ["bash"]
