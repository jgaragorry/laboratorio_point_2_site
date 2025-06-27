#!/bin/bash

RG="rg-vpn-p2s-lab"

echo "⚠️ ¡Vas a eliminar toda la infraestructura del laboratorio P2S!"
echo "⏳ Si fue usado menos de 1 hora, su costo es menor a $0.10 USD"
echo "¿Estás seguro? (s/n): "
read confirm

if [[ "$confirm" != "s" ]]; then
  echo "❌ Cancelado por el usuario."
  exit 1
fi

echo "🧹 Eliminando grupo de recursos $RG ..."
az group delete -n $RG --yes --no-wait

while az group exists -n $RG; do
  echo "⏳ Esperando a que se elimine el grupo de recursos..."
  sleep 10
done

echo "✅ Laboratorio eliminado completamente."