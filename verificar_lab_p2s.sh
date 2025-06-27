#!/bin/bash

RG="rg-vpn-p2s-lab"
GW_NAME="vpn-gateway"

echo "🔍 Verificando estado del Gateway..."
az network vnet-gateway show -g $RG -n $GW_NAME --query "{name:name,location:location,provisioningState:provisioningState,vpnClientConfiguration:vpnClientConfiguration}" -o table

echo "🌐 Verifica desde el portal de Azure si ya puedes descargar el cliente VPN (OpenVPN)"
echo "📎 Una vez descargado, puedes conectarte desde Linux así:"
echo ""
echo "    sudo apt install openvpn unzip -y"
echo "    unzip <vpn-client.zip>"
echo "    cd <carpeta-extraida>"
echo "    sudo openvpn <archivo.ovpn>"
echo ""
echo "📌 Verás 'Initialization Sequence Completed' si se conectó bien."