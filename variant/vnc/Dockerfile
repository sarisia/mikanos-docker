ARG BASE=ghcr.io/sarisia/mikanos:latest
FROM ${BASE}

ARG NOVNC_VERSION=1.2.0
ARG WEBSOCKIFY_VERSION=0.9.0

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    python-is-python3 \
    python3-numpy \
 && apt-get clean -y \
 && rm -rf /var/lib/apt/lists

# Install noVNC
# Thanks https://github.com/microsoft/vscode-dev-containers/blob/e646d525e1e5ca5d872977905eb23424e36dd558/script-library/docs/desktop-lite.md
RUN mkdir -p /usr/local/novnc \
 && curl -L -o /tmp/novnc.zip https://github.com/novnc/noVNC/archive/v${NOVNC_VERSION}.zip \
 && unzip /tmp/novnc.zip -d /usr/local/novnc/ \
 && cp /usr/local/novnc/noVNC-${NOVNC_VERSION}/vnc.html /usr/local/novnc/noVNC-${NOVNC_VERSION}/index.html \
 && curl -L -o /tmp/websockify.zip https://github.com/novnc/websockify/archive/v${WEBSOCKIFY_VERSION}.zip \
 && unzip /tmp/websockify.zip -d /usr/local/novnc/ \
 && ln -sf /usr/local/novnc/websockify-${WEBSOCKIFY_VERSION} /usr/local/novnc/noVNC-${NOVNC_VERSION}/utils/websockify \
 && rm -rf /tmp/novnc.zip /tmp/websockify.zip

COPY novnc.sh /usr/local/share

ENTRYPOINT ["/usr/local/share/novnc.sh"]
# We need to re-define CMD here! See:
# https://docs.docker.com/engine/reference/builder/#understand-how-cmd-and-entrypoint-interact
CMD ["/bin/sh", "-c", "echo Container started ; trap \"exit 0\" 15; while sleep 1 & wait $!; do :; done"]
