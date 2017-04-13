-----------------------------------------------------------------
-- Proyecto puerta automatica 2017
-- pausa incial antes de cargar programa.lua
-----------------------------------------------------------------

print("********************************")
print("** PROYECTO PUERTA AUTOMATICA **")
print("********************************")
print("En programa.lua esta el programa. No modificar init.lua")
print("Para detener el arranque utiliza... inicio:stop() ")
print("Comienza la cuenta de 5 segundos...")
inicio=tmr.create()
inicio:register(5000, tmr.ALARM_SINGLE, 
function (timer) 
        print("Arrancando programa.lua")
         if file.exists("programa.lua") then
            print(" fichero existe!")
            dofile("programa.lua")
        else
            print(" fichero no encontrado")
        end
end)
inicio:start()
