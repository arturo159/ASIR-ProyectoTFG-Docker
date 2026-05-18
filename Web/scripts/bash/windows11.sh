#!/bin/bash
echo "Iniciando script de despliegue de Windows (dockurr/windows)..."

# 1. Comprobación de permisos
if ! docker ps > /dev/null 2>&1; then
    echo -e "\e[33m[!] Se requieren permisos de administrador para usar Docker.\e[0m"
    # Si falla, usamos sudo solo para los comandos de Docker
    DOCKER_CMD="sudo docker"
else
    # Si funciona, el usuario ya está en el grupo docker
    DOCKER_CMD="docker"
fi

containerName="__VM_NAME__"
exists=$($DOCKER_CMD ps -a --format '{{.Names}}' | grep -E "^$containerName$")

if [ -z "$exists" ]; then
    echo "El contenedor no existe. Creando e instalando Windows..."
    
    # 2. Comprobación de KVM para rendimiento
    kvmArg=""
    envKvm="N"
    
    if [ -e /dev/kvm ]; then
        echo -e "\e[32m KVM detectado. Rendimiento acelerado por hardware ACTIVADO.\e[0m"
        kvmArg="--device=/dev/kvm"
        envKvm="Y"
    else
        echo -e "\e[33m ADVERTENCIA: /dev/kvm no encontrado.\e[0m"
        echo -e "\e[33m Windows se instalará usando emulación. Irá muy lento.\e[0m"
        echo -e "\e[33m Por favor, activa la virtualización anidada en la BIOS/Máquina Virtual.\e[0m"
        sleep 3
    fi

    # 3. Despliegue del contenedor
    $DOCKER_CMD run -d \
        --name "$containerName" \
        -p 8006:8006 \
        --cap-add NET_ADMIN \
        $kvmArg \
        -e VERSION="win11" \
        -e RAM_SIZE="4G" \
        -e CPU_CORES="2" \
        -e DISK_SIZE="64G" \
        -e KVM="$envKvm" \
        -v windows_disk:/storage \
        dockurr/windows
fi

# 4. Iniciar contenedor (por si estaba apagado)
$DOCKER_CMD start "$containerName" > /dev/null

echo "Esperando a que el sistema levante los servicios..."
sleep 5

echo "Abriendo Windows en el navegador..."

# Como el script principal se ejecuta como usuario normal, esto abrirá Firefox sin errores
firefox "http://localhost:8006" 2>/dev/null || xdg-open "http://localhost:8006" > /dev/null 2>&1 &
