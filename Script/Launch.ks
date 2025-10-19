// For use with Orbit-1, needs tweaking to adapt to other platforms based off of TWR and other variables.

 function main {
    doLaunch().
    doAscent().
    doGlide().
    doCircularize().
 }
function doLaunch {
    lock throttle to 1.
    stage.
}
function doAscent {
    //lock targetPitch to 88.963 - 1.03287 * alt:radar^0.409511.
    //set targetDirection to 90.
    //lock steering to heading(targetDirection, targetPitch).

    //For the initial ascent, we want our steering to be straight
    //up and rolled due east
    until apoapsis >= 80000 {
    IF SHIP:VELOCITY:SURFACE:MAG < 100 {
        //This sets our steering 90 degrees up and yawed to the compass
        //heading of 90 degrees (east)
        declare global MYSTEER TO HEADING(90,90).

    //Once we pass 100m/s, we want to pitch down ten degrees
    } ELSE IF SHIP:VELOCITY:SURFACE:MAG >= 100 AND SHIP:VELOCITY:SURFACE:MAG < 200 {
        declare global MYSTEER TO HEADING(90,80).
        PRINT "Pitching to 80 degrees" AT(0,15).

    //Each successive IF statement checks to see if our velocity
    //is within a 100m/s block and adjusts our heading down another
    //ten degrees if so
    } ELSE IF SHIP:VELOCITY:SURFACE:MAG >= 200 AND SHIP:VELOCITY:SURFACE:MAG < 300 {
        declare global MYSTEER TO HEADING(90,70).
        PRINT "Pitching to 70 degrees" AT(0,15).

    } ELSE IF SHIP:VELOCITY:SURFACE:MAG >= 300 AND SHIP:VELOCITY:SURFACE:MAG < 400 {
        declare global MYSTEER TO HEADING(90,60).
        PRINT "Pitching to 60 degrees" AT(0,15).

    } ELSE IF SHIP:VELOCITY:SURFACE:MAG >= 400 AND SHIP:VELOCITY:SURFACE:MAG < 500 {
        declare global MYSTEER TO HEADING(90,50).
        PRINT "Pitching to 50 degrees" AT(0,15).

    } ELSE IF SHIP:VELOCITY:SURFACE:MAG >= 500 AND SHIP:VELOCITY:SURFACE:MAG < 600 {
        declare global MYSTEER TO HEADING(90,40).
        PRINT "Pitching to 40 degrees" AT(0,15).

    } ELSE IF SHIP:VELOCITY:SURFACE:MAG >= 600 AND SHIP:VELOCITY:SURFACE:MAG < 700 {
        declare global MYSTEER TO HEADING(90,30).
        PRINT "Pitching to 30 degrees" AT(0,15).

    } ELSE IF SHIP:VELOCITY:SURFACE:MAG >= 700 AND SHIP:VELOCITY:SURFACE:MAG < 800 AND altitude >= 40000 {
        declare global MYSTEER TO HEADING(90,11).
        PRINT "Pitching to 20 degrees" AT(0,15).

    //Beyond 800m/s, we can keep facing towards 10 degrees above the horizon and wait
    //for the main loop to recognize that our apoapsis is above 100km
    } ELSE IF SHIP:VELOCITY:SURFACE:MAG >= 800 AND altitude >= 40000 {
        declare global MYSTEER TO HEADING(90,10).
        PRINT "Pitching to 10 degrees" AT(0,15).
    }
    lock steering to MYSTEER.
      doAutoStage().
    print "Apoapsis: " + round(apoapsis). wait 0.5.
}
print "Apoapsis reached: " + apoapsis.
}
function doAutoStage {
        if not(defined oldThrust) {declare global oldThrust to ship:availablethrust.}
        when ship:availablethrust < (oldThrust - 10) then {
            stage. wait 1.
            declare global oldThrust to ship:availablethrust.
            print "Staging.".
        }
    }
function doGlide{
    lock throttle to 0.
    lock steering to prograde.
} 
function doCircularize {
    until altitude >= (apoapsis - 250) {
    print "Altitude: " + altitude. wait 1.
    }
    print "Attempting LKO Insertion". wait 0.5.
    set ShipTWR to (7.63*(ship:mass*1000)/(ship:availablethrust*1000)).
    print "Ship Mass: " + ship:mass*1000.
    print "Ship Available Thrust: " + ship:availablethrust*1000.
    print "Ship TWR: " + ShipTWR.
    until periapsis >= (apoapsis - 5000) {
        if ship:availablethrust > 0 and apoapsis < 100000 {
            if ShipTWR <= 1.8 { 
                lock throttle to 1.0.
            }
            else {
                lock throttle to 0.75.
            }
            print "Periapsis: " + periapsis. wait .5.
        }
        else if apoapsis >= 100000 and ship:availablethrust > 0 and (apoapsis - periapsis) > 10000 {
            lock throttle to 0.
                if altitude >= (apoapsis - 10) {
                    lock throttle to .25.
                    print "Periapsis: " + periapsis. 
                    print "Apoapsis: " + apoapsis.
                    wait 1.
                }
            }
        else if (apoapsis - periapsis) <= 10000 {
            print "LKO Achieved.".
            print "Apoapsis: " + apoapsis.
            print "Periapsis: " + periapsis.
            lock throttle to 0.
            lock steering to prograde.
            BREAK.
            } 
        else {
            print "LKO Achieved.".
            print "Apoapsis: " + apoapsis.
            print "Periapsis: " + periapsis.
            lock throttle to 0.
            lock steering to prograde.
            BREAK.
        } }
}
main().