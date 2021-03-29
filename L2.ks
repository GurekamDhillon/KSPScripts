SET GEAR TO ALT:RADAR<200.
LOCK THROTTLE TO 0.
LOCK STEERING TO RETROGRADE.
PRINT "STARTING LANDING".
STAGE.
LOCK THROTTLE TO 1. 
WAIT UNTIL PERIAPSIS <= 0.
LOCK THROTTLE TO 0.
local speed is AIRSPEED.
local t is MISSIONTIME.
local gSurf is BODY:MU / BODY:RADIUS^2.
local g is BODY:MU / (BODY:RADIUS + ALTITUDE)^2.
local aNet is g.
local prevQ is SHIP:Q.
local runmode is 1.
local offset is ALT:RADAR + 1.
until ALT:RADAR <= offset {
    if MISSIONTIME - t > 0.5 {
        set g to BODY:MU / (BODY:RADIUS + ALTITUDE)^2.
        set aNet to (aNet + (AIRSPEED - speed) / (MISSIONTIME - t) + thrott * MAXTHRUST / SHIP:MASS)/2.
        set speed to AIRSPEED.


        set t to MISSIONTIME.
        print "g: " + g + "        " at(0,14).
        print "aNet: " + aNet + "       " at(0,15).
        print "Q: " + SHIP:Q + "       " at(0,16).
        if prevQ > SHIP:Q {
            set aNet to g.
        }
        set prevQ to SHIP:Q.
    }
    // Wait for suicide altitude
    if runmode = 1 {
        local aEst is (aNet - g) * 0.6 + gSurf.
        local a is MAXTHRUST / SHIP:MASS - aEst.
        local stopDist is (AIRSPEED - 1)^2 / (2 * a).
        print "Max A: " + a + "       " at(0,18).
        print "Speed: " + AIRSPEED + "        " at(0,19).
        print "Target Alt: " + stopDist + "        " at(0,20).
        if (stopDist >= (ALT:RADAR - offset)) {
            set runmode to 2.
        }
    }
    // Slow down!
    if runmode = 2 {
        //local aEst is (aNet - g) / 2 + gSurf.
        local a is (AIRSPEED - 1)^2 / (2 * (ALT:RADAR - offset)).
        local thrust is (a + gSurf) * SHIP:MASS.
        set thrott to thrust / (MAXTHRUST + 0.001).
        print "Target A: " + a + "        " at(0,22).
        print "Thrust: " + thrust + "        " at(0,23).
        print "Throttle: " + thrott + "         " at(0,24).
        if thrott < 0.8 or ALT:RADAR <= offset {
            set thrott to 0.
            set runmode to 1.
        }
    }
}
print "Landing... " + AIRSPEED.
local twr is (MAXTHRUST + 0.001) / SHIP:MASS / g.
set thrott to 0.95 / twr.
wait until SHIP:STATUS = "LANDED".
print "Landed".
set thrott to 0.
wait 60.




