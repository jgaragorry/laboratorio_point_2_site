## 🧠 README.md - Laboratorio VPN Point-to-Site (P2S) en Azure

### 🎯 Objetivo General
Que los estudiantes aprendan a desplegar una VPN P2S en Azure para conexión remota segura usando Linux y Azure CLI, con foco en bajo costo y automatización.

---

## ✅ ¿Qué aprenderás?
- Crear una red virtual con subred para VPN.
- Configurar un gateway de VPN compatible con OpenVPN.
- Probar la conectividad desde clientes remotos (Linux preferido por costo).
- Automatizar con scripts: creación, verificación y eliminación.
- Usar `az cli` con buenas prácticas, etiquetas y limpieza de recursos.

---

## 🧪 Requisitos
- Azure CLI instalado (o usar Azure Cloud Shell)
- Cuenta gratuita o de estudiante en Azure
- Permisos para crear grupos de recursos y redes
- Linux como sistema operativo cliente para pruebas (opcional: Windows)

---

## 💸 Estimación de Costo
> ⚠️ Si solo usas esta infraestructura por menos de 1 hora y luego la eliminas con el script, el costo estimado **no supera los $0.10 USD**.

---

## 📂 Estructura del Repositorio

```bash
point_to_site_p2s/
├── crear_lab_p2s.sh         # Crea toda la infraestructura
├── verificar_lab_p2s.sh     # Verifica que todo esté correcto
├── eliminar_lab_p2s.sh      # Elimina la infraestructura (con confirmación y espera)
└── README.md                # Este archivo
```

---

## ⚙️ Scripts incluidos

### 🔹 `crear_lab_p2s.sh`
Crea:
- Grupo de recursos con etiquetas
- VNet con subred
- Subred especial `GatewaySubnet`
- IP pública para Gateway (con SKU Standard y asignación estática)
- Gateway VPN (`VpnGw1`, compatible con OpenVPN)

📌 **Aviso Importante**:
> ⏳ El proceso de creación del Gateway VPN puede tardar entre 25 a 40 minutos. No cierres la terminal mientras se despliega.

### 🔹 `verificar_lab_p2s.sh`
Verifica:
- Estado del Gateway
- IPs asignadas (pública y privadas)
- Rango de clientes VPN
- Muestra comandos para probar desde Linux (OpenVPN)

🔧 **Prueba desde Linux (cliente):**
```bash
sudo apt install openvpn unzip -y
unzip <vpn-client.zip>
cd <carpeta-extraida>
sudo openvpn <nombre_config.ovpn>
```

📌 Si ves `Initialization Sequence Completed`, ¡la VPN está funcionando!

📎 El archivo `vpn-client.zip` lo puedes descargar desde el **Portal de Azure** después de que el gateway haya sido creado completamente:

1. Ir al recurso del gateway VPN
2. Buscar opción: **"Descargar cliente VPN"**
3. Seleccionar protocolo OpenVPN
4. Descargar ZIP y moverlo al cliente Linux o Windows

---

### 🔹 ¿Y si quiero probarlo desde Windows?

1. Descargar el ZIP del cliente VPN desde el portal de Azure
2. Instalar [OpenVPN GUI para Windows](https://openvpn.net/community-downloads/)
3. Copiar los archivos `.ovpn` dentro del directorio `C:\Program Files\OpenVPN\config`
4. Abrir OpenVPN GUI como administrador y conectar

✅ También mostrará `Initialization Sequence Completed` al conectarse con éxito.

---

### 🔹 `eliminar_lab_p2s.sh`
- Pide confirmación explícita
- Muestra mensaje de advertencia:
  > ⚠️ Este laboratorio cuesta menos de $0.10 USD si se elimina en menos de una hora.
- No devuelve el prompt hasta que todos los recursos han sido eliminados correctamente

---

## 🚀 Instrucciones Rápidas

### 🔐 Iniciar sesión:
```bash
az login
```

### ▶️ Crear el laboratorio:
```bash
chmod +x crear_lab_p2s.sh
./crear_lab_p2s.sh
```

### 🔎 Verificar el laboratorio:
```bash
./verificar_lab_p2s.sh
```

### 🗑️ Eliminar el laboratorio:
```bash
./eliminar_lab_p2s.sh
```

---

## 🧑‍🏫 Autor
Jose Garagorry - Instructor de Redes y Arquitecturas Azure

---

## 📜 Scripts

### 🔧 crear_lab_p2s.sh
```bash
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
```

### 🔍 verificar_lab_p2s.sh
```bash
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
```

### 🗑 eliminar_lab_p2s.sh
```bash
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
```
