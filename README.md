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
- Linux como sistema operativo cliente para pruebas

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

Si ves `Initialization Sequence Completed`, ¡la VPN está funcionando!

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
