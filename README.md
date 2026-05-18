<h1>ASIR-ProyectoTFG-Docker 👾</h1>

<p>
  Sistema para la creación y gestión de aulas virtuales con Docker y terminales ligeras.<br/>
  Generación de una interfaz gráfica para la creación de contenedores de trabajo y su conexión a través de un sistema de terminales ligeras.
</p>

<br/>

<h2>📋 Índice</h2>
<ul>
  <li><a href="#descripcion">Descripción del Proyecto</a></li>
  <li><a href="#dockerspawn">DockerSpawn — Página Web</a></li>
  <li><a href="#scripts">Scripts de Automatización</a></li>
  <li><a href="#portainer">Portainer — Gestión de Contenedores</a></li>
  <li><a href="#estructura">Estructura del Repositorio</a></li>
  <li><a href="#requisitos">Requisitos Previos</a></li>
  <li><a href="#equipo">Equipo</a></li>
</ul>

<br/>

<h2 id="descripcion">📌 Descripción del Proyecto</h2>
<p>
  Este proyecto tiene como objetivo proporcionar una solución completa para el despliegue y gestión de máquinas virtuales ligeras mediante contenedores Docker.
  Está compuesto por tres partes principales que trabajan conjuntamente:
</p>
<ul>
  <li>Una <strong>interfaz web</strong> (DockerSpawn) para la descarga de scripts personalizados.</li>
  <li>Un conjunto de <strong>scripts de automatización</strong> para Windows y Linux.</li>
  <li>Una instancia de <strong>Portainer</strong> para la gestión visual de los contenedores Docker.</li>
</ul>

<br/>

<h2 id="dockerspawn">🌐 DockerSpawn — Página Web</h2>
<p>
  DockerSpawn es la interfaz web del proyecto. Permite al usuario configurar y descargar un script personalizado en pocos pasos, sin necesidad de tocar ningún archivo manualmente.
</p>

<h3>¿Cómo funciona?</h3>
<ol>
  <li>El usuario selecciona el <strong>sistema operativo</strong> de la máquina virtual que quiere desplegar (Xubuntu, Kali Linux o Windows 10/11).</li>
  <li>Elige el <strong>tipo de script</strong> según su plataforma: Bash para Linux o PowerShell para Windows.</li>
  <li>Introduce el <strong>nombre que quiere darle</strong> a la máquina virtual.</li>
  <li>Pulsa <em>Descargar Script</em> y obtiene el archivo listo para ejecutar.</li>
</ol>

<h3>Tecnologías</h3>
<ul>
  <li>HTML5 + CSS3 — Interfaz estática, sin frameworks.</li>
  <li>JavaScript — Lógica de selección, validación y descarga dinámica del script con el nombre personalizado inyectado.</li>
  <li>Compatible con <strong>GitHub Pages</strong> — No requiere servidor ni backend.</li>
</ul>

<h3>Scripts disponibles</h3>
<table>
  <thead>
    <tr>
      <th>Sistema Operativo</th>
      <th>Bash (.sh)</th>
      <th>PowerShell (.ps1)</th>
    </tr>
  </thead>
  <tbody>
    <tr><td>Xubuntu 24.04</td><td>✅</td><td>✅</td></tr>
    <tr><td>Kali Linux 2024</td><td>✅</td><td>✅</td></tr>
    <tr><td>Windows 10</td><td>✅</td><td>✅</td></tr>
    <tr><td>Windows 11</td><td>✅</td><td>✅</td></tr>
  </tbody>
</table>

<br/>

<h2 id="scripts">⚙️ Scripts de Automatización</h2>
<p>
  Cada script descargado desde la web realiza las siguientes acciones de forma automática:
</p>
<ol>
  <li>Comprueba si el contenedor con el nombre indicado ya existe en Docker.</li>
  <li>Si no existe, lo crea y lo configura completamente (instalación de escritorio, VNC, noVNC, etc.).</li>
  <li>Arranca el contenedor y lanza los servicios necesarios.</li>
  <li>Abre el navegador apuntando a la interfaz gráfica de la máquina virtual.</li>
</ol>

<h3>Nombre de la máquina virtual</h3>
<p>
  El nombre que el usuario introduce en la web se inyecta directamente en el script antes de la descarga.
  Internamente, los scripts usan el placeholder <code>__VM_NAME__</code> que es reemplazado por JavaScript en el momento de generar el archivo.
</p>

<h3>Scripts de Windows</h3>
<p>
  Los scripts de Windows detectan automáticamente si el sistema dispone de KVM para virtualización por hardware.
  Si está disponible, lo activan para mayor rendimiento. Si no, informan al usuario y continúan por emulación.
</p>

<br/>

<h2 id="portainer">🐳 Portainer — Gestión de Contenedores</h2>
<p>
  Portainer es la herramienta elegida para la administración visual de todos los contenedores Docker del proyecto.
  Proporciona una interfaz web completa que permite gestionar contenedores, volúmenes, redes, imágenes y stacks sin necesidad de usar la terminal.
</p>

<h3>Instalación manual</h3>

<p><strong>Paso 1 — Crear el volumen persistente:</strong></p>

```bash
docker volume create portainer_data
```

<p><strong>Paso 2 — Desplegar el contenedor:</strong></p>

```bash
docker run -d \
  --name portainer \
  --restart=always \
  -p 8000:8000 \
  -p 9443:9443 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
  portainer/portainer-ce:latest
```

<p><strong>Paso 3 — Acceder a la interfaz:</strong></p>

```
https://localhost:9443
```

<p>
  En el primer acceso, Portainer pedirá crear el usuario administrador.
  Después, seleccionar el entorno local (ya aparece automáticamente al haber montado el socket de Docker) y pulsar <em>Connect</em>.
</p>

<h3>Automatización de Portainer</h3>
<p>
  Se han creado scripts de automatización tanto para Windows como para Linux que verifican si Docker y Portainer están instalados en el sistema.
  Si no se encuentran, los instalan automáticamente y dejan el servicio listo para su uso.
  Estos scripts también están disponibles para descarga desde la web.
</p>

<br/>

<h2 id="estructura">📁 Estructura del Repositorio</h2>

```
/
├── index.html              ← Página principal (descarga de scripts)
├── index.css               ← Estilos de la página principal
├── docs.html               ← Documentación y guía de Portainer
├── docs.css                ← Estilos de la página de documentación
└── scripts/
    ├── bash/
    │   ├── ubuntu.sh
    │   ├── kali.sh
    │   ├── windows10.sh
    │   └── windows11.sh
    └── powershell/
        ├── ubuntu.ps1
        ├── kali.ps1
        ├── windows10.ps1
        └── windows11.ps1
```

<br/>

<h2 id="requisitos">🛠️ Requisitos Previos</h2>
<ul>
  <li><a href="https://www.docker.com/products/docker-desktop/">Docker Desktop</a> instalado y en ejecución.</li>
  <li>En Linux: permisos suficientes para ejecutar comandos Docker (usuario en el grupo <code>docker</code>).</li>
  <li>En Windows: WSL2 habilitado para compatibilidad con los scripts Bash.</li>
  <li>Conexión a internet para la descarga de imágenes Docker la primera vez.</li>
</ul>

<br/>

<h2 id="equipo">👥 Equipo</h2>

<table>
  <thead>
    <tr>
      <th>Nombre</th>
      <th>Rol</th>
    </tr>
  </thead>
  <tbody>
    <tr><td>Arturo Gordo Arco</td><td>Desarrollador</td></tr>
    <tr><td>Victor Sevilla Perez</td><td>Desarrollador</td></tr>
    <tr><td>José Sánchez Galeote</td><td>Desarrollador</td></tr>
    <tr><td>Cristhian Camacho Tinoco</td><td>Desarrollador</td></tr>
    <tr><td>Roberto Rodriguez Zuñiga</td><td>Desarrollador</td></tr>
  </tbody>
</table>

<br/>

<h2>🎓 Tutor del Proyecto</h2>
<p>Raúl Jiménez Benítez</p>
