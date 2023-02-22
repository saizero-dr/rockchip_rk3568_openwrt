#!/bin/sh

WLAN_SDIO_PATH="/sys/bus/mmc/devices/mmc2:0001"
SDIO_DEV="fe2c0000.mmc"

if [ ! -d "${WLAN_SDIO_PATH}" ]; then
    exit 0
fi

while true; do
    WLAN_RADIO0_PATH="$(wifi status | jq -r .radio0.config.path | grep ${SDIO_DEV})"

    if [ x"${WLAN_RADIO0_PATH}" = x"" ]; then
        sleep 15
        continue
    fi

    WLAN_RADIO0_AUTOSTART="$(wifi status | jq -r .radio0.autostart)"
    if [ x"${WLAN_RADIO0_AUTOSTART}" != x"true" ]; then
        sleep 15
        continue
    fi

    WLAN_RADIO0_DISABLED="$(wifi status | jq -r .radio0.disabled)"

    if [ x"${WLAN_RADIO0_DISABLED}" != x"false" ]; then
        sleep 15
        continue
    fi

    WLAN_RADIO0_RETRY_FAILED="$(wifi status | jq -r .radio0.retry_setup_failed)"

    if [ x"${WLAN_RADIO0_RETRY_FAILED}" != x"true" ]; then
        sleep 15
        continue
    fi

    WLAN_RADIO0_PENDING="$(wifi status | jq -r .radio0.pending)"

    if [ x"${WLAN_RADIO0_PENDING}" = x"true" ]; then
        sleep 15
        continue
    fi

    WLAN_RADIO0_STATE="$(wifi status | jq -r .radio0.up)"

    if [ x"${WLAN_RADIO0_STATE}" = x"true" ]; then
        sleep 15
        continue
    fi

    wifi up radio0

    sleep 10
done
