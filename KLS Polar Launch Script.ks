// Script to put a payload into LKO. For use with the Kerbal Launch System and Kerbal Launch System-Heavy, WIP.

function main {
    doLaunch().
    doAscent().
    doAutoStage().
    doGlide().
    doAttitudeControl().
    doCircularize().
 }
function doLaunch {
    lock throttle to 1.
    stage.
}
function doAscent {
    //lock targetPitch to 90.47 - 0.00169961 * alt:radar + 5.63331*10^(-9) * alt:radar^2. //Derived from quadratic line of best fit via Wolfram Alpha. Needs optimized.
    lock targetPitch to 88.9562 - 0.00423786 * alt:radar + 5.86265*10^(-8) * alt:radar^2. //Aggressive Test ascent profile
    set targetDirection to 355. //We want to pitch to the north to achieve a polar orbit.
    lock steering to heading(targetDirection, targetPitch). //Should keep steering locked to pitch determined by the targetPitch formula.
}
function doAutoStage { //Shouldn't need this for KLS since it is a SSTO, should only be need for KLS-Heavy
        local oldThrust is ship:maxthrust.
        when ship:maxthrust < (oldThrust - 1000) then {
            stage. wait 1.
            set oldThrust to ship:maxthrust.
            print "Staging.".
        }
    }
function doGlide{
    wait until apoapsis >= 85000.
    lock throttle to 0.
    lock steering to prograde.
    rcs on.
    wait 5.
    rcs off.
    //global progradeVector is ship:facing:forevector.
    print "Apoapsis reached: " + round(apoapsis).   
    wait until altitude >= 60000.
    stage.
    print "Staging Fairing.".
}
function doAttitudeControl{
    until ship:altitude > apoapsis - 2200 {
        print "Angle between forevector and prograde: " + vang(ship:facing:forevector,ship:prograde:vector).
               if vang(ship:facing:forevector,ship:prograde:vector) > 2{
                until vang(ship:facing:forevector,ship:prograde:vector) < 0.5 {
                rcs on.
                 }
               }
               else {
                rcs off.
               }
               wait 0.5.
    }
    rcs off.
}
function doCircularize {
    wait until altitude >= (apoapsis - 2000).
    print "Attempting LKO Insertion". wait 0.5.
    until periapsis >= (apoapsis - 5000) {
        if apoapsis < 100000 {
                lock throttle to 1.0.
        }
        else if apoapsis >= 100000 and periapsis <= 70000 {
            lock throttle to 0.
                if altitude >= (apoapsis - 10) {
                    lock throttle to .35.
                    wait .5.
                }
            }
        else if (apoapsis - periapsis) <= 5000 {
            lock throttle to 0.
            lock steering to prograde.
            SAS on.
            print "LKO Achieved.".
            print "Apoapsis: " + apoapsis.
            print "Periapsis: " + periapsis.
            BREAK.
            } 
        }
}
main().
