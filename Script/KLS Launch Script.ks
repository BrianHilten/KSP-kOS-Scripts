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
    set targetDirection to 90. //We want to pitch to the east along Kerbin's prograde vector.
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
    print "Apoapsis reached: " + round(apoapsis).   
    wait until altitude >= 60000.
    stage.
    print "Staging Fairing.".
    PANELS ON. //Should deploy solar panels if applicable
}
function doAttitudeControl{
    until ship:altitude > apoapsis - 2200 {
        //print "Angle between forevector and prograde: " + vang(ship:facing:forevector,ship:prograde:vector).
               if vang(ship:facing:forevector,ship:prograde:vector) > 2{ //Finds angle between forevector and the prograde vector to determine drift
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
            doAttitudeControl().
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
//Experimental doCircularize function using apoapsis ETA to adjust throttle to reduce time to LKO.
// function doCircularize {
//     wait until altitude >= (apoapsis - 2000) and SHIP:ORBIT:ETA:APOAPSIS <= 20.
//     print "Attempting LKO Insertion". wait 0.5.
//     until periapsis >= (apoapsis - 5000) {
//         set currentETA to SHIP:ORBIT:ETA:APOAPSIS.
//         if currentETA < 30 {
//                 lock throttle to 1.0.
//         }
//         else if SHIP:ORBIT:ETA:APOAPSIS > 30 {
//             lock throttle to .5.
//             }
//         else if (apoapsis - periapsis) <= 5000 {
//             lock throttle to 0.
//             lock steering to prograde.
//             SAS on.
//             print "LKO Achieved.".
//             print "Apoapsis: " + apoapsis.
//             print "Periapsis: " + periapsis.
//             BREAK.
//             } 
//         }
// }
//Experimental doCircularize function.
// function doCircularize {
//     wait until altitude >= (apoapsis - 2000).
//     print "Attempting LKO Insertion". wait 0.5.
//     lock throttle to 1.
//     local OrbitEcc is ORBIT:eccentricity.
//     until OrbitEcc < 0.003 {
//         set OrbitEcc to ORBIT:eccentricity.
//         print OrbitEcc.
//         if OrbitEcc > 0.05  and apoapsis <= 100000 {
//                 lock throttle to 1.0.
//         }
//         else if OrbitEcc > 0.05 and apoapsis > 100000 {
//             lock throttle to 0.
//             //wait until altitude >= (apoapsis - 25).
//             when altitude >= (apoapsis - 25) then {
//                 lock throttle to .5.
//                 wait until ORBIT:eccentricity <= 0.05.
//             }
//         }
//         else if OrbitEcc <= 0.05 and OrbitEcc > 0.005 {
//             lock throttle to .5.
//                 // if altitude >= (apoapsis - 10) {
//                 //     lock throttle to .25.
//                 //     wait .2.
//                 // }
//             }
//         else if OrbitEcc <= 0.005 {
//             lock throttle to .25.
//         }
//     }
//     lock throttle to 0.
//     lock steering to prograde.
//     SAS on.
//     print "LKO Achieved.".
//     print "Apoapsis: " + apoapsis.
//     print "Periapsis: " + periapsis.
// }

//LEGACY CODE BELOW
    //For the initial ascent, we want our steering to be straight
    //up and rolled due east
    //     until apoapsis >= 80000 {
    //     IF SHIP:VELOCITY:SURFACE:MAG < 50 {
    //         declare global MYSTEER TO HEADING(90,90).
    //     } ELSE IF SHIP:VELOCITY:SURFACE:MAG >=50 AND SHIP:VELOCITY:SURFACE:MAG < 100 {
    //         declare global MYSTEER TO HEADING(90,85).
    //     } ELSE IF SHIP:VELOCITY:SURFACE:MAG >= 100 AND SHIP:VELOCITY:SURFACE:MAG < 200 {
    //         declare global MYSTEER TO HEADING(90,80).
    //         PRINT "Pitching to 80 degrees" AT(0,15).
    //     } ELSE IF SHIP:VELOCITY:SURFACE:MAG >= 200 AND SHIP:VELOCITY:SURFACE:MAG < 300 {
    //         declare global MYSTEER TO HEADING(90,70).
    //         PRINT "Pitching to 70 degrees" AT(0,15).

    //     } ELSE IF SHIP:VELOCITY:SURFACE:MAG >= 300 AND SHIP:VELOCITY:SURFACE:MAG < 400 {
    //         declare global MYSTEER TO HEADING(90,60).
    //         PRINT "Pitching to 60 degrees" AT(0,15).

    //     } ELSE IF SHIP:VELOCITY:SURFACE:MAG >= 400 AND SHIP:VELOCITY:SURFACE:MAG < 500 {
    //         declare global MYSTEER TO HEADING(90,50).
    //         PRINT "Pitching to 50 degrees" AT(0,15).

    //     } ELSE IF SHIP:VELOCITY:SURFACE:MAG >= 500 AND SHIP:VELOCITY:SURFACE:MAG < 600 {
    //         declare global MYSTEER TO HEADING(90,40).
    //         PRINT "Pitching to 40 degrees" AT(0,15).

    //     } ELSE IF SHIP:VELOCITY:SURFACE:MAG >= 600 AND SHIP:VELOCITY:SURFACE:MAG < 700 {
    //         declare global MYSTEER TO HEADING(90,30).
    //         PRINT "Pitching to 30 degrees" AT(0,15).

    //     } ELSE IF SHIP:VELOCITY:SURFACE:MAG >= 700 AND SHIP:VELOCITY:SURFACE:MAG < 800 AND altitude >= 40000 {
    //         declare global MYSTEER TO HEADING(90,11).
    //         PRINT "Pitching to 20 degrees" AT(0,15).

    //     //Beyond 800m/s, we can keep facing towards 10 degrees above the horizon and wait
    //     //for the main loop to recognize that our apoapsis is above 100km
    //     } ELSE IF SHIP:VELOCITY:SURFACE:MAG >= 800 AND altitude >= 40000 {
    //         declare global MYSTEER TO HEADING(90,10).
    //         PRINT "Pitching to 10 degrees" AT(0,15).
    //     }
    //     lock steering to MYSTEER.
    //       doAutoStage().
    //     print "Apoapsis: " + round(apoapsis). wait 0.5.
    // }
    // print "Apoapsis reached: " + apoapsis.
//LEGACY CODE ABOVE