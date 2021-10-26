#!/bin/bash
# Bash Menu Script Example

resetBluetooth() {
    sudo sed -i 's|^ExecStart=/usr/lib/bluetooth/bluetoothd.*$|ExecStart=/usr/lib/bluetooth/bluetoothd -C -P sap,input,avrcp|g' /lib/systemd/system/bluetooth.service
    echo "Bluez Input Plugin Workaround Applied."
    echo "Resetting Bluetooth..."
    sudo systemctl daemon-reload
    sudo systemctl restart bluetooth.service
    echo "Bluetooth reset."
}

connectSwitch() {
    local PS3='Connect options: '
    local options=("Connect New Switch" "Reconnect Switch" "Load Amiibo" "Go Back")
    local opt
    select opt in "${options[@]}"; do
        case $opt in
        "Connect New Switch")
            echo "Connecting new switch..."
            sudo python3 run_controller_cli.py PRO_CONTROLLER $amiiboPath
            ;;
        "Reconnect Switch")
            echo "Reconecting to paired switch..."
            sudo python3 run_controller_cli.py PRO_CONTROLLER -r auto $amiiboPath
            ;;
        "Load Amiibo")
            read -p "Please drag the Amiibo BIN file here:" AMIIBOPATH
            amiiboPath="--nfc ${AMIIBOPATH}"
            ;;
        "Go Back")
            return
            ;;
        *) echo "invalid option $REPLY" ;;
        esac
    done
}

# main menu
echo "JoyControl Launch Script (v0.1) by Emma Maguire"
PS3='Please select an option: '
options=("Connect to Switch" "Reset Bluetooth" "Quit")
select opt in "${options[@]}"; do
    case $opt in
    "Connect to Switch")
        connectSwitch
        ;;
    "Reset Bluetooth")
        resetBluetooth
        ;;
    "Quit")
        exit
        ;;
    *) echo "invalid option $REPLY" ;;
    esac
done
