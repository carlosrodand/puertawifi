# Página en construcción
# Puerta automática con control Wi-Fi
![puerta](imagenes/puerta.jpg)
### IES Torre Atalaya
Realizado por:
* Carlos Rodríguez
* Mario Gómez
* Javier Figueroa

Profesor: Jose Antonio Romero
## Resumen
Nuestro proyecto de tecnología consiste en la construcción de una puerta corredera automática y controlada inalámbricamente mediante Wi-Fi, por ejemplo con un smartphone.

El funcionamiento de la puerta es el siguiente: 
1. Cuando pulsamos el botón de apertura, el semáforo se pone en rojo, empieza a sonar un zumbido a intervalos regulares y la puerta comienza a abrirse. 
2. Cuando la puerta se abre totalmente, se detiene. Se para el zumbido y se pone el semáforo en verde. Permanecerá abierta durante el intervalo de tiempo que tenga programado.
3. Después del periodo de apertura programado, el semáforo se pone en rojo, el zumbido empieza a sonar y la puerta se cierra.
4. Si durante el cierre se detecta un obstáculo en el camino de la puerta, la puerta retrocede a la posición de apertura y el zumbido suena con más frecuencia. Se continúa en el paso 2.
5. Cuando la puerta se cierra totalmente se detiene la puerta, se apaga el semáforo y el zumbido.

Además de esto se comprueba regularmente el nivel de luz ambiente mediante un sensor crepuscular y cuando el nivel de luz baja se encienden las farolas de la calle. Cuando el nivel de luz es alto, las farolas se apagan.

El control del sistema lo realiza un módulo ESP8266 con conexión Wi-Fi. Hemos programado un pequeño servidor web que permite controlar y programar la puerta. A **través de la Wi-Fi** se puede:
* abrir la puerta
* cambiar el tiempo de apertura de la puerta
* cambiar el volumen del altavoz
* apagar o encender las farolas o activar su funcionamiento automático

Estas funciones se pueden realizar a traves de un **navegador web** una vez que nos hemos conectado al punto de acceso Wi-Fi que genera el módulo ESP. 

También podemos usar la **aplicación Android** que hemos desarrollado con App Inventor para controlar la puerta.

## Diseño mecánico
El diseño mecánico de la puerta corredera está basado en el mecanismo "tornillo-tuerca", donde un motor eléctrico, mediante un sistema de poleas y correa, hace girar el tornillo (varilla roscada) que consigue que la puerta se deslice al estar fijada a dos tuercas que están insertadas en la varilla roscada. Para mejorar la suavidad de funcionamiento, la varilla roscada está sujeta mediante dos rodamientos de bolas.

![puerta corredera](imagenes/puerta-corredera2.jpg)

Materiales para la construcción:
* chapas y listones de madera para la estructura (recuperados)
* varilla roscada M8 y tuercas (ferretería)
* 2 rodamientos de bolas (reusados de rueda patín)
* motor eléctrico (reusado de lector DVD)

## Diseño electrónica

Para controlar nuestra puerta hemos usado un módulo ESP8266 con firmware NodeMCU. Este módulo tiene un microcontrolador que se puede programar usando el lenguaje Lua y además tiene conectividad Wi-Fi. Con ayuda de unos interruptores fin de carrera podemos detectar cuando la puerta llega al final de la apertura o cierre. También hemos usado un sensor de obstáculos por infrarrojos para detectar obstaculos en el camino de la puerta y poder evitar accidentes. El motor lo controlamos con ayuda de un circuito integrado L293 que se encarga de dar corriente al motor y cambiar la polaridad dependiendo del estado de dos salidas de nuestro módulo ESP8266.

Materiales para la electrónica:
* placa de desarrollo ESP8266 NodeMCU (programación)
* CI L293 (corriente al motor)
* LED rojo y verde, y resistencia 220 Ohms (semáforo)
* pulsador (botón apertura)
* sensor infrarrojos (obstáculos) 
* 2 interruptores fin carrera (reusado de una impresora)
* altavoz (reusado de una impresora)
* LDR (fotoresistencia) y resistencia 10 KOhms (para sensor luz)
* 2 LEDS blancos y resistencia 220 Ohms (farolas)

## Programación

## Aplicación móvil

La [App para Android está disponible en la galería](http://ai2.appinventor.mit.edu/?galleryId=6638221398900736) de [App Inventor](http://ai2.appinventor.mit.edu). Se puede buscar por el nombre (App Puerta Wi-Fi). También se ha exportado e incluido en el repositorio [APP_Puerta.aia](AppInventor2/APP_Puerta.aia)
## Referencias

