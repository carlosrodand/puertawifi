print("Sonido listo")
altavoz = 8
volumen = 400

function sonido( freq,  dur, vol)
  pwm.setup(altavoz, freq, vol)
  pwm.start(altavoz)
  finsonido=tmr.create()
  finsonido:register(dur, tmr.ALARM_SINGLE, function (timer)
    pwm.stop(altavoz)
  end) 
  finsonido:start()
end

  alarma=tmr.create()
  alarma:register(1000, tmr.ALARM_AUTO, function (timer)
    sonido(400,200,volumen)
  end) 
  
  alarma2=tmr.create()
  alarma2:register(400, tmr.ALARM_AUTO, function (timer)
    sonido(400,200,volumen)
  end) 
