clearscreen.
set targetAp to 80000.
set targetPa to 80000.
set runmode to 2.
if ALT:RADAR < 50 {
	set runmode to 1.
}
until runmode = 0 {
	if runmode = 1 {
		print "Starting Launch".
		lock steering to up + R(0,0,90).
		lock throttle to 1.0.
		stage.
		set runmode to 2.
	} else if runmode = 2 {
		set dostage to false.
		LIST ENGINES IN engines.  
		for eng in engines {
			if eng:ignition = true and eng:flameout = true { set dostage to true. } 
		}
		if dostage { stage. }
		set engineCount to engines:length.
		print engineCount.
		if engineCount <= 4 {
			lock steering to up + R(0,-15,180).
		}
		if engineCount < 3{
			set runmode to 3.
		}
	} else if runmode = 3 {
		wait until ALTITUDE > 10000.
		lock steering to up + R(0,-20,90).
		wait until ALTITUDE > 15000.
		lock steering to up + R(0,-40,90).
		wait until ALTITUDE > 20000.
		lock steering to up + R(0,-60,90).
		wait until ALTITUDE > 30000.
		lock steering to up + R(0,-70,90).
		wait until ALTITUDE > 40000.
		lock steering to up + R(0,-85,90).
		wait until ALTITUDE > 50000.
		lock steering to up + R(0,-90,90).
		set runmode to 4.
	} else if runmode = 4 {
		until APOAPSIS >= targetAp {
		  print APOAPSIS.
		}
		lock throttle to 0.
		wait until ALTITUDE >= APOAPSIS-100.
		lock throttle to 1.
		wait until PERIAPSIS >= targetPa.
		lock throttle to 0.
		stage.
		set runmode to 5.
	}
	
}
