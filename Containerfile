FROM docker.io/library/debian:trixie-slim


RUN <<EOF
set -xeu
printf "APT::Install-Recommends \"0\";" \
  > /etc/apt/apt.conf.d/no-install-recommends

apt-get update -y
apt-get upgrade -y

apt-get install -y \
  bind9-dnsutils \
  bind9-host \
  ca-certificates \
  curl \
  git \
  gnupg2 \
  iproute2 \
  less \
  make \
  strace \
  zsh
EOF

RUN <<EOF
curl -fsSL https://jan-matejka.github.io/debian-ppa/install | sh
apt-get install -y \
  dram \
  jm-util
EOF

RUN <<EOF
set -e

useradd -m --shell /bin/zsh user
chsh -s /bin/zsh root

cd /root
mkdir -p git/dotfiles
git clone -q https://github.com/jan-matejka/dotfiles-zsh.git git/dotfiles/zsh
make -C git/dotfiles/zsh install
make -C git/dotfiles/zsh install HOME=/home/user USER=user
install -d --owner=user /app /test /src
EOF

CMD ["zsh"]

ARG IMAGE_BUILD_CTIME=
ARG IMAGE_BUILD_COMMIT=
ARG IMAGE_BUILD_REF=
ARG IMAGE_BUILD_BY=

ENV JMA_DEBIAN_IMAGE_BUILD_CTIME=${IMAGE_BUILD_CTIME} \
  JMA_DEBIAN_IMAGE_BUILD_COMMIT=${IMAGE_BUILD_COMMIT} \
  JMA_DEBIAN_IMAGE_BUILD_REF=${IMAGE_BUILD_REF} \
  JMA_DEBIAN_IMAGE_BUILD_BY=${IMAGE_BUILD_BY}
