//For launching Aphrodite 2 mission into LKO.
lock throttle to .70.
stage.

lock targetPitch to 88.963 - 1.03287 * alt:radar^0.409511.
set targetDirection to 90.
lock steering to heading(targetDirection, targetPitch).

set oldThrust to ship:availablethrust.
until apoapsis > 30000 {
  if ship:availablethrust < (oldThrust - 10) {
    stage. wait 1.
    set oldThrust to ship:availablethrust.
  }
  print "Apoapsis: " + apoapsis. wait 1.
}
lock throttle to 1.
until apoapsis >= 80000 {
    print "Apoapsis: " + apoapsis. wait 1.
  }
set LaunchAp to apoapsis.
lock throttle to 0.
lock steering to prograde.
print "Apoapsis reached: " + LaunchAp.
until altitude >= (LaunchAp - 250) {
    print "Altitude: " + altitude. wait 1.
}
print "Attempting LKO Insertion". wait 0.5.
until periapsis >= (apoapsis - 5000) {
        if ship:availablethrust > 0 and apoapsis < 100000 {
            lock throttle to .5.
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
        }
}
if ship:availablethrust > 0 {
print "LKO Achieved.".
print "Apoapsis: " + apoapsis.
print "Periapsis: " + periapsis.
lock throttle to 0.
lock steering to prograde.
}