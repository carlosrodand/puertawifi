--configuración de puerto ADC
if adc.force_init_mode(adc.INIT_ADC)
then
  node.restart()
  return -- reset
end

dofile("sonido.lua") -- carga programa de sonido
dofile("wifi.lua") -- carga programa de wifi-servidor web
--variables
rojo=0
verde=1
pulsador=2
motor1=3
motor2=4
fincar1=5
fincar2=6
sensor=7
farolas=12
niveldeluz=600
tiempocerrar=5000

gpio.mode(rojo,gpio.OUTPUT) -- led rojo
gpio.write(rojo,0)

gpio.mode(verde,gpio.OUTPUT) -- led verde
gpio.write(verde,0)

gpio.mode(motor1,gpio.OUTPUT)  -- motor1
gpio.write(motor1,0)

gpio.mode(motor2,gpio.OUTPUT) -- motor2
gpio.write(motor2,0)

gpio.mode(farolas,gpio.OUTPUT) --  led farolas
gpio.write(farolas,0)

gpio.mode(fincar1,gpio.INPUT) -- para leer findes de carrera
gpio.mode(fincar2,gpio.INPUT) 
gpio.mode(sensor,gpio.INPUT) -- leer sensor cercania

-- funcion para cerrar
function cerrar()

 if(gpio.read(fincar1)==0) then
    estado="cerrando"  
    print (estado)
    fincarrera1() --para que se pare
    return
    end

   if gpio.read(sensor)==0 then -- hay un obstaculo
      temporizador:start() --retrasar cierre
      print("El sensor detecta un obstaculo... esperar")
      sonido(220,500,512) -- sonido 
      return -- terminar aqui la funcion
   end
   gpio.write(rojo,1)--semaforo rojo
   gpio.write(verde,0)

   gpio.write(motor1,1)--acctivar motor
   gpio.write(motor2,0)
   estado="cerrando"
   sonido(400,200,volumen)
   alarma:start()
   print(estado)
 
end

temporizador=tmr.create()  --temporizador de cerrado
temporizador:register(tiempocerrar, tmr.ALARM_SEMI, cerrar)

-- estado de la puerta al principio
estado="cerrado"

print(estado)

--contra rebote botones
function debounce (func)
    local last = 0
    local delay = 500000
    return function (...)
        local now = tmr.now()
        local delta = now - last
        if delta < 0 then delta = delta + 2147483647 end; -- proposed because of delta rolling over, https://github.com/hackhitchin/esp8266-co-uk/issues/2
        if delta < delay then return end;

        last = now
        return func(...)
    end
end
  
  luminosidad=tmr.create() -- temporizador control luz auto
  luminosidad:register(1000, tmr.ALARM_AUTO, function (timer)
   luz = adc.read(0)--leo nivel de luz
   if luz < niveldeluz then
   gpio.write(farolas,1)
   else
   gpio.write(farolas,0)
   end
   print("nivel luz "..luz)
   --sonido(600,20,volumen)
    end) 
  luminosidad:start()


function sensordistancia(level)--fun. sensordistancia
   print("puerta interrumpida")

   if estado=="cerrando" then

    if(gpio.read(fincar2)==0) then
    estado="abriendo"
    print (estado)
    fincarrera2()  --para que se pare
    return
    end

   gpio.write(rojo,1)--semaforo rojo
   gpio.write(verde,0)
   
   gpio.write(motor1,0)--acctivar motor
   gpio.write(motor2,1)
   estado="abriendo"
   alarma:stop()
   alarma2:start()
   print(estado)
   end

end
   
function fincarrera1(level)--fun. fincarrera1 cerrar
   print("Pulsacion fin1 cerrar")

   if estado=="cerrando" then
     
     gpio.write(rojo,0)--apagando semaforo
     gpio.write(verde,0)
   
     gpio.write(motor1,0)--parando motor
     gpio.write(motor2,0)
     alarma:stop()
     estado="cerrado"
     print(estado)
   
     end
end

function fincarrera2(level)--fun.fincarrera2 abrir
   print("Pulsacion fin2 abrir")
   
  if estado=="abriendo" then

     gpio.write(rojo,0)--semaforo verde
     gpio.write(verde,1)
  
     gpio.write(motor1,0)--parar motor
     gpio.write(motor2,0)
     alarma:stop()
     alarma2:stop()
     estado="abierto"
     print(estado)
     
     temporizador:start()--encender temporizador
     end
end

function boton(level)--fun. boton
   print("Pulsación botón")

   if estado=="cerrado" then

   if(gpio.read(fincar2)==0) then
    estado="abriendo"
    print (estado)
    fincarrera2()  --para que se pare
    return
    end

     gpio.write(rojo,1)--semaforo rojo
     gpio.write(verde,0)
   
     gpio.write(motor1,0)--encender motor
     gpio.write(motor2,1)
     sonido(400,200,volumen)
     alarma:start()
     estado="abriendo"
     print(estado)
 
   end
   
end -- fin fun. boton

 gpio.mode(pulsador, gpio.INT, gpio.PULLUP)--boton apertura
 gpio.trig(pulsador,"down",debounce(boton))
 

 gpio.mode(fincar1, gpio.INT, gpio.PULLUP)--fin de carrera1
 gpio.trig(fincar1,"down",debounce(fincarrera1))
 
 gpio.mode(fincar2, gpio.INT, gpio.PULLUP)--fin de carrera2
 gpio.trig(fincar2,"down",debounce(fincarrera2))

 gpio.mode(sensor, gpio.INT, gpio.PULLUP)--sensor de distancia
 gpio.trig(sensor,"down",debounce(sensordistancia))

sonido(1000,75,512) -- sonido agudo
