FROM debian:bullseye-slim

# Env variables
ARG DOCKER_VERSION
ARG DOCKER_COMPOSE_VERSION
ENV DOCKER_VERSION ${DOCKER_VERSION:-20.10.12}
ENV DOCKER_COMPOSE_VERSION ${DOCKER_COMPOSE_VERSION:-1.29.2}

# Install build dependencies
RUN set -eux; \
  apt-get update; \
  apt-get install -y --no-install-recommends curl ca-certificates

# Install Docker
RUN set -eux; \
  curl -L https://download.docker.com/linux/static/stable/x86_64/docker-$DOCKER_VERSION.tgz | tar xfzv - --strip-components 1 --directory /usr/local/bin/; \
  dockerd --version; \
  docker --version

# Install Docker Compose
RUN set -eux; \
  curl -L "https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/bin/docker-compose; \
  chmod 755 /usr/bin/docker-compose; \
  docker-compose --version

# Install kubectl
RUN set -eux; \
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"; \
  chmod 750 kubectl && mv kubectl bin/; \
  kubectl version --client=true

# Install kustomize
RUN set -eux; \
  curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash; \
  chmod 750 kustomize && mv kustomize bin/; \
  kustomize version

# Clean up
RUN set -eux; \
  apt-get clean
