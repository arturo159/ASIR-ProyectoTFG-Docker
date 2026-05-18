Write-Host 'Iniciando script de Windows...' -ForegroundColor Cyan

$containerName = '__VM_NAME__'
$exists = docker ps -a --format '{{.Names}}' | Select-String '^windows-gui$'

if (-not $exists) {
    Write-Host 'Creando e instalando Windows...'
    
    $kvmCheck = wsl -- ls /dev/kvm 2>$null
    $envKvm = 'N'

    if ($kvmCheck -match '/dev/kvm') {
        Write-Host 'KVM detectado. Rendimiento hardware ACTIVADO.' -ForegroundColor Green
        $envKvm = 'Y'
        
        docker run -d --name $containerName -p 8006:8006 --cap-add NET_ADMIN --device=/dev/kvm -e VERSION=win10 -e RAM_SIZE=4G -e CPU_CORES=2 -e DISK_SIZE=64G -e KVM=$envKvm -v windows_disk:/storage dockurr/windows
    } else {
        Write-Host 'ADVERTENCIA: KVM no detectado.' -ForegroundColor Yellow
        Write-Host 'Windows ira por emulacion (lento).' -ForegroundColor Yellow
        Start-Sleep -Seconds 3
        
        docker run -d --name $containerName -p 8006:8006 --cap-add NET_ADMIN -e VERSION=win10 -e RAM_SIZE=4G -e CPU_CORES=2 -e DISK_SIZE=64G -e KVM=$envKvm -v windows_disk:/storage dockurr/windows
    }
}

docker start $containerName | Out-Null

Write-Host 'Esperando a que levanten los servicios...'
Start-Sleep -Seconds 5

Start-Process 'http://localhost:8006'
