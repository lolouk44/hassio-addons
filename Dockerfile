ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8


# adjust here the environment variables
ENV HCI_DEV hci0
ENV MISCALE_MAC 00:00:00:00:00:00
ENV MQTT_PREFIX miScale
ENV MQTT_HOST 192.168.0.1
ENV MQTT_USERNAME username
ENV MQTT_PASSWORD password
ENV MQTT_PORT 1883
ENV TIME_INTERVAL 30

ENV USER1_GT 70
ENV USER1_SEX male
ENV USER1_NAME Jo
ENV USER1_HEIGHT 175
ENV USER1_DOB 1990-01-01

ENV USER2_LT 35
ENV USER2_SEX female
ENV USER2_NAME Serena
ENV USER2_HEIGHT 95
ENV USER2_DOB 1990-01-01

ENV USER3_SEX female
ENV USER3_NAME Missy
ENV USER3_HEIGHT 150
ENV USER3_DOB 1990-01-01


WORKDIR /opt/miscale
COPY src /opt/miscale

RUN apt-get update && apt-get install -y \
    bluez \
    python-pip \
    libglib2.0-dev && \
    rm -rf /var/lib/apt/lists/*

RUN pip install -r requirements.txt


# Copy in docker scripts to root of container...
COPY dockerscripts/ /

RUN chmod a+x /entrypoint.sh
RUN chmod a+x /cmd.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/cmd.sh"]