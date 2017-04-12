-- Crea una red WiFi y un servidor de páginas web
-- Modificado de http://randomnertutorials.com/esp8266-web-server/

wifi.setmode(wifi.SOFTAP)  -- wifi en modo punto de acceso
CONFIGURACION={}
CONFIGURACION.ssid="PuertaWiFi"  -- nombre wifi
CONFIGURACION.pwd="torreatalaya" -- clave
wifi.ap.config(CONFIGURACION)

if(servidorWeb~=nil) then -- si el servidor existe lo cerramos
    servidorWeb:close()
    servidorWeb=nil
end

print("Servidor web en direccion "..wifi.ap.getip())

servidorWeb=net.createServer(net.TCP) -- crea un servidor TCP
-- pone al servidor a escuchar en el puerto 80 (HTTP)
servidorWeb:listen(80,function(conn)
    conn:on("receive",function(conn, mensaje) 
   --print(mensaje)
    -- buscamos algo del tipo "GET pagina HTTP/1.1", me interesa la "pagina"
    local _, _, pagina = string.find(mensaje, "GET (.+) HTTP");
    
    print("Peticion de pagina : "..pagina)

    -- buscar la cadena en la peticion/pagina Web
    if (string.find(pagina,"pin=ON")) then
        -- llegó la orden pin=ON
        print("pin=ON")
        luminosidad:stop()
        gpio.write(farolas,1)
        sonido(1000,75,512) -- sonido agudo
    end
    if (string.find(pagina,"pin=OFF")) then
        -- llegó la orden pin=ON
        print("pin=OFF")
        luminosidad:stop()
        gpio.write(farolas,0)
        sonido(1000,75,512) -- sonido agudo
    end
     if (string.find(pagina,"auto")) then
        -- llegó la orden pin=ON
        print("auto")
        luminosidad:start()
        sonido(1000,75,512) -- sonido agudo        
    end
     if (string.find(pagina,"abrir")) then
        -- llegó la orden pin=ON
        print("pin=abrir")
        boton()
        sonido(1000,75,512) -- sonido agudo       
    end
     if (string.find(pagina,"mute")) then
        -- llegó la orden pin=ON
        print("mute")
        volumen=0  
        sonido(1000,75,512) -- sonido agudo        
    end
     if (string.find(pagina,"bajo")) then
        -- llegó la orden pin=ON
        print("bajo")
        volumen=20 
        sonido(1000,75,512) -- sonido agudo        
    end
      if (string.find(pagina,"alto")) then
        -- llegó la orden pin=ON
        print("alto")
        volumen=400
        sonido(1000,75,512) -- sonido agudo         
    end
     if (string.find(pagina,"5s")) then
        -- llegó la orden pin=ON
        print("5s")
        tiempocerrar=5000
        temporizador:interval(tiempocerrar)
        sonido(1000,75,512) -- sonido agudo        
    end
     if (string.find(pagina,"30s")) then
        -- llegó la orden pin=ON
        print("30s")
        tiempocerrar=30000
        temporizador:interval(tiempocerrar)
        sonido(1000,75,512) -- sonido agudo        
    end
     if (string.find(pagina,"60s")) then
        -- llegó la orden pin=ON
        print("60s")
        tiempocerrar=60000
        temporizador:interval(tiempocerrar)
        sonido(1000,75,512) -- sonido agudo        
    end
    --mandar la pagina web
    resp= 'HTTP/1.1 200 OK\n\n'   -- respuesta OK es necesaria!
        ..'<!DOCTYPE HTML>'
        ..'<html><head><meta content="text/html; charset=utf-8">'
        ..'<title>ESP8266 Servidor Web</title></head>'
        ..'<body><h1>Control de PUERTA</h1>'
        ..'<h2>IES Torre Atalaya</h2>'
        ..'<h2>Puerta &nbsp &nbsp <a href="?abrir"><button style="height:50px; width:150px"> abrir </button></a></h2>'
        ..'<h2>Farolas &nbsp &nbsp <a href="?pin=ON"><button style="height:50px; width:150px"> ON </button></a>'
        ..'&nbsp &nbsp <a href="?pin=OFF"><button style="height:50px; width:150px"> OFF </button></a>' 
        ..'&nbsp &nbsp <a href="?auto"><button style="height:50px; width:150px"> auto </button></a> </h2>' 
        ..'<h2>Sonido &nbsp &nbsp <a href="?mute"><button style="height:50px; width:150px"> mute </button></a>'
        ..'&nbsp &nbsp <a href="?bajo"><button style="height:50px; width:150px"> bajo </button></a>' 
        ..'&nbsp &nbsp <a href="?alto"><button style="height:50px; width:150px"> alto </button></a> </h2>' 
        ..'<h2>Tiempo de cerrado &nbsp &nbsp <a href="?5s"><button style="height:50px; width:150px"> 5s </button></a>'
        ..'&nbsp &nbsp <a href="?30s"><button style="height:50px; width:150px"> 30s </button></a>' 
        ..'&nbsp &nbsp <a href="?60s"><button style="height:50px; width:150px"> 60s </button></a> </h2>' 
        ..'</body></html>'
    conn:send(resp)
    conn:on("sent", function(conn) conn:close() end)
    end)
  end)
