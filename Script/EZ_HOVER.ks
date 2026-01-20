//k values:
set kP_alt to 0.22. //kP for determining target_v from altitude error
set kP_vel to 0.05. //kP for determining throttle required to reach target_v
set kI to 0.005. //Be wary of windup
set kD to 0.01.


set pid_output to 0.
set lastP to 0.
set totalP to 0.
set lastTime_vel to 0.


function pid_loop_alt { //Generates our target descent velocity for input into pid_loop_vel
    parameter target.
    parameter current.

    set P to (current-target). //Our proportional gain based off of current error

    set pid_output to max(-150,min(P*-kP_alt,2)). //clamping
    
    //Print results to console for tracking
    
    print "P(outer): " + P.
    print "Target velocity: " + pid_output.

    return pid_output.
}


function pid_loop_vel { //Compares current velocity to target velocity to adjust throttle accordingly
    parameter target_vel.
    parameter current_vel.

    set currentTime to time:seconds.
    set gravity to constant():g*(body:mass / (altitude + body:radius)^2).
    set hover_throttle to ship:mass*gravity/ship:maxThrust.

    set P to (target_vel-current_vel). //Our proportional gain based off of current error
    set I to 0.
    set D to 0.


    if(lastTime_vel > 0){
        set I to totalP + (P + lastP)/2 * (currentTime-lastTime_vel). //Our accumulated error (area under "curve" created by data points over time)
        set D to (P - lastP) / (currentTime-lastTime_vel). //Our rate of change (slope of line between two consecutive data points)
    }
    
   

    set pid_output to P*kP_vel + I*kI + D*kD.
    //Update for next loop:
    set lastTime_vel to currentTime.
    set lastP to P.
    if (pid_output <= 1 AND pid_output >= 0){ //To combat integrator windup
        set totalP to I.
    }
    //Print results to console for tracking
    print "P(inner v): " + P.
    print "I: " + I.
    print "D: " + D.
    print "Throttle: " + pid_output.
    print "Total P: " + totalP.

    return max(0,min(pid_output + hover_throttle,1)). //To prevent saturation and ensure throttle gets a value 0 <-> 1
}

function distanceToGround {
    // Distance to Ground: altitude - body:geopositionOf(ship:position):terrainHeight - distance from center of craft to bottom.
    return altitude - body:geopositionOf(ship:position):terrainHeight. 
}

//Liftoff to take us to a higher altitude than we want to test deceleration ability of controller
lock steering to heading (90,90).
lock throttle to 0.
stage.
GEAR OFF.

//For testing from orbit
// stage.
//     lock steering to retrograde.
//     wait 20.
//     //Takes VDS from stable orbit to suborbital landing trajectory
//     //Things we need to know: Periapsis of current orbit (how do we know if the periapsis is low enough? maybe there are parameters for "sea" level vs ground level)
//     //is there a way to ensre we are landing somewhere safe? (future integration of SCANSAT slope data possible?)
//     local deorbit_alt is (ship:geoposition:terrainheight).
//     print "Terrain Height below current ship position: " + deorbit_alt.
//     print "Distance to ground at current ship position: " + distanceToground().
//     until periapsis <= ship:geoposition:terrainheight { //Should compare current orbit periapsis to the ship's current distance above ground level (NOT "sea" level)
//         lock throttle to 1.
//     }
//     lock throttle to 0.

//Test p_loop
set autoThrottle to 0.
lock throttle to autoThrottle.
switch to 0. //For logging
set startTime to time:seconds. //For logging

until stage:liquidfuel < 5 {
    set dt to 0.05.
    set v_target to pid_loop_alt(body:geopositionOf(ship:position):terrainHeight, altitude). //Use this for landing on the surface
    //set v_target to pid_loop_alt(500, altitude). //Use this for hovering at a specific altitude
    if(TIME:SECONDS - lastTime_vel >= dt){ //Updates every 0.1 seconds
        // set acc_v to pid_loop_vel(v_target, ship:verticalspeed)*ship:maxthrust / ship:mass - gravity. //Outputs our desired vertical acceleration
        // set autoThrottle to ship:mass*(acc_v+gravity)/ship:maxthrust. //Use our PID function to set throttle value, includes gravity feedforward
        set autoThrottle to pid_loop_vel(v_target, ship:verticalspeed).
        print "Commanded thrust: " + autoThrottle.
        CLEARSCREEN.
    } 
    if(distanceToGround() <= 15){
        GEAR ON.
    }
    if(distanceToGround() < 6){ //let lander drop rest of distance onto landing legs
        BREAK.
    }
    //log(time:seconds - startTime) + "," + altitude + "," + autoThrottle to "pid_drop1.csv".
    wait 0.001. //To (hopefully) not blow up kOS CPU
}

//recover
lock throttle to 0.
//stage. //deploy recovery chutes.
switch to 1.
