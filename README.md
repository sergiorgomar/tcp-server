# 🚀 Swift TCP Server

Este es un proyecto experimental escrito en Swift que implementa un **servidor TCP** con soporte para **comunicación bidireccional**, diseñado para enviar y recibir mensajes similares a un WebSocket, pero utilizando sockets TCP puros.

> ⚠️ **Nota:** Este servidor fue creado con fines educativos para explorar y profundizar en el manejo de `Network` y `NWConnection` en Swift. No está optimizado para producción.


## Requisitos previos

Para poder ejecutar el proyecto requiere tener [instalado swift]("https://www.swift.org/install/macos/") en su sistema. 

Este proyecto se escribió usando la versión 6.0.3. 

Verifique su instalación y la versión de swift en su sistema ejecutando `swift --version` en su terminal.

## Sobre el proyecto

El propósito principal de este proyecto es:

- Experimentar el flujo de conexión de clientes mediante TCP.
- Implementar un protocolo de mensajes propio de forma simple.
- Enviar y recibir datos de manera bidireccional (tipo "echo server").
- Profundizar en el manejo de `NWListener`, `NWConnection` y sus eventos.
- Experimentar con la estructura de servidores sin usar WebSockets o frameworks HTTP.


### ¿Qué hace?

- Escucha conexiones TCP entrantes.
- Asigna un `UUID` a cada conexión y las almacena en memoria.
- Lee datos desde cada conexión, los decodifica en UTF-8 y los emite a todas las conexiones.
- Implementa un pequeño "protocolo" para estructurar los mensajes.

### El protocolo 

Este servidor utiliza un protocolo experimental y simple basado en texto plano para enviar mensajes a través de TCP. Los mensajes están delimitados por saltos de línea (`\n`) y siguen el formato:

```INSTRUCCION|DATOS\n```


#### Comandos implementados

##### Lado del servidor

`OK` Notifica al cliente que una operación fue exitosa.

**Ejemplo:** `OK|a1b2c3 WELCOME TO THE SERVER\n`

`BAD` Notifica al cliente que ocurrió un error procesando su solicitud.

**Ejemplo:** `BAD|INVALID FORMAT\n`


##### Lado del cliente

`EMIT` Permite al cliente emitir un mensaje mensajes a todas las conexiones del servidor.

**Ejemplo:** `EMIT|Hello, this is a test message.\n`



## Estructura del proyecto

```bash
📁 tcp-server/
├── main.swift              # Punto de entrada de la aplicación
├── core.swift              # Contiene la lógica central de la aplicación, validaciones y flujo del protocolo personalizado
├── socket.swift            # Funciones para manejar las conexiones
├── run.sh                  # Script para ejecutar la aplicación (Linux y Macos)
├── run.bat                 # Script para ejecutar la aplicación (Windows)
└── README.md               # Este archivo
```

## ¿Como ejecutar?

`swift build` para compilar la aplicacion. 
`swift run` para ejecutar el servidor.

Para abrir con XCode, necesita abrir el archivo Package.swift directo en el editor.


## Futuras mejoras y escalabilidad

Este proyecto está enfocado en el aprendizaje, debido a esto el proyecto pretende explorar las capas del modelo OSI (4 a 7). 

- **Autenticación y seguridad:** Añadir mecanismos de autenticación, autorización y cifrado TLS para proteger las conexiones y datos intercambiados.

- **Evolución del protocolo:** Refinar y robustecer el protocolo personalizado para que sea práctico, seguro y escalable, incorporando características como codificación, compresión, negociación, y un esquema estructurado de mensajes que incluya solicitudes, respuestas, errores, notificaciones y manejo de estados dentro del protocolo.

- **Desarrollo de aplicaciones:** Utilizar esta tecnología como base para crear aplicaciones reales, como sistemas de chat en tiempo real, notificaciones push, juegos multijugador o plataformas IoT.