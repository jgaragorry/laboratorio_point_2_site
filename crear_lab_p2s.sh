#!/bin/bash

set -e

RG="rg-vpn-p2s-lab"
LOC="eastus"
VNET="vnet-p2s"
SUBNET="subnet-p2s"
GW_SUBNET="GatewaySubnet"
GW_PUBLIC_IP="gw-ip"
GW_NAME="vpn-gateway"
GW_SKU="VpnGw1"
VPN_CLIENT_ADDRESS_POOL="172.16.201.0/24"

echo "🔐 Iniciando sesión en Azure..."
az login

echo "🔧 Creando grupo de recursos..."
az group create -n $RG -l $LOC --tags autor=gmtech proyecto=lab_vpn_p2s

echo "🌐 Creando red virtual y subred..."
az network vnet create \
  -g $RG -n $VNET --address-prefix 10.10.0.0/16 \
  --subnet-name $SUBNET --subnet-prefix 10.10.1.0/24

echo "🧱 Agregando GatewaySubnet..."
az network vnet subnet create \
  -g $RG --vnet-name $VNET -n $GW_SUBNET --address-prefix 10.10.255.0/27

echo "🌐 Creando IP pública para el gateway..."
az network public-ip create \
  -g $RG -n $GW_PUBLIC_IP --sku Standard --allocation-method Static

echo "🚪 Creando Gateway de VPN... (esto tomará ~30 minutos)"
az network vnet-gateway create \
  -g $RG -n $GW_NAME \
  --public-ip-addresses $GW_PUBLIC_IP \
  --vnet $VNET \
  --gateway-type Vpn \
  --vpn-type RouteBased \
  --sku $GW_SKU \
  --client-protocols OpenVPN \
  --address-prefixes $VPN_CLIENT_ADDRESS_POOL \
  --no-wait

echo "✅ Laboratorio P2S creado exitosamente."