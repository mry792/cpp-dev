from gcc:13.2.0

RUN apt update && \
    apt install --yes --no-install-recommends \
        cmake \
        curl \
        grep \
        lsb-release \
        pipx \
        sudo \
        vim \
      && \
    rm --recursive --force /var/lib/apt/lists/*

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
ARG CONAN_EXE=/home/${DOCKER_USER}/.local/bin/conan
RUN pipx install conan==1.58 && \
    rm --recursive --force /home/${DOCKER_USER}/.cache
RUN ${CONAN_EXE} config init && \
    ${CONAN_EXE} config set general.revisions_enabled=1 && \
    ${CONAN_EXE} profile update settings.compiler.libcxx=libstdc++11 default && \
    ${CONAN_EXE} profile update settings.compiler.cppstd=20 default && \
    echo "core:default_build_profile = default" >> /home/${DOCKER_USER}/.conan/global.conf

CMD ["bash"]
