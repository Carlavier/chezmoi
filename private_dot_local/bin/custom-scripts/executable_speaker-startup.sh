#!/bin/bash

sleep 10

SPEAKER_MAC="00:02:3C:C0:EE:44"

bluetoothctl power on >/dev/null
bluetoothctl connect "$SPEAKER_MAC" >/dev/null
