FROM python:3.8-slim
LABEL io.hass.version="0.1.17a" io.hass.type="addon" io.hass.arch="armhf|aarch64|i386|amd64"
WORKDIR /opt/miscale
COPY src /opt/miscale

RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    bluez \
    python-pip \
    libglib2.0-dev && \
    rm -rf /var/lib/apt/lists/*

RUN pip install -r requirements.txt

# Copy in docker scripts to root of container...
COPY dockerscripts/ /

RUN chmod +x /entrypoint.sh
RUN chmod +x /cmd.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/cmd.sh"]