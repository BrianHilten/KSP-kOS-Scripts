//To be updated to include 2D Dynamics (tilt loop)
//Throttle Gains:
set kP_alt to 0.048.
set kP_vel to 0.08.
set kI to 0.0009. //Suffers from integral windup
set kD to 0.02.

//Tilt Gains
set kP_vel_h to 0.5.
set kI_vel_h to 0.01.
set kD_vel_h to 0.02.

set pid_output to 0.
set lastP to 0.
set totalP to 0.
set lastTime_vel to 0.

function pid_loop_alt { //Generates our target descent velocity for input into pid_loop_vel
    parameter target.
    parameter current.

    set currentTime to time:seconds.

    set P to (target-current). //Our proportional gain based off of current error

    set pid_output to max(-150,min(P*kP_alt,-1)). //clamping
    
    //Print results to console for tracking
    
    print "P(outer): " + P.
    print "Target velocity: " + pid_output.

    return pid_output.
}

function pid_loop_vel { //Compares current velocity to target velocity to adjust throttle accordingly
    parameter target_vel.
    parameter current_vel.
    parameter commanded_tilt.

    set currentTime to time:seconds.
    set gravity to constant():G*(body:mass / (altitude + body:radius)^2).
    set hover_throttle to ship:mass*gravity/ship:maxThrust * SIN(commanded_tilt+90).

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

function pid_loop_tilt { //Compares current horizontal velocity to target velocity to adjust tilt
    parameter target_vel_h.
    parameter current_vel_h.

    set currentTime to time:seconds.

    set P to (target_vel_h-current_vel_h). //Our proportional gain based off of current error
    set I to 0.
    set D to 0.


    if(lastTime_vel > 0){
        set I to totalP + (P + lastP)/2 * (currentTime-lastTime_vel). //Our accumulated error (area under "curve" created by data points over time)
        set D to (P - lastP) / (currentTime-lastTime_vel). //Our rate of change (slope of line between two consecutive data points)
    }
    
   

    set pid_output to P*kP_vel_h + I*kI_vel_h + D*kD_vel_h.
    //Update for next loop:
    set lastTime_vel to currentTime.
    set lastP to P.
    if (pid_output <= 90 AND pid_output >= 0){ //To hopefully combat integrator windup
        set totalP to I.
    }
    //Print results to console for tracking
    print "P(inner): " + P.
    print "I: " + I.
    print "D: " + D.
    print "Throttle: " + pid_output.
    print "Total P: " + totalP.
    if ship:groundspeed <= 0.5 { //To prevent accelerating in the other direction
        set lastP to 0.
        set totalP to 0.
        return 0.
    }
    return max(0,min(pid_output,90)). //To prevent saturation and ensure tilt gets a value 0 <-> 90 degrees
}

function distanceToGround {
    // Distance to Ground: altitude - body:geopositionOf(ship:position):terrainHeight - distance from center of craft to bottom.
    return altitude - body:geopositionOf(ship:position):terrainHeight. 
}

//Test p_loop
set autoThrottle to 0.
set autoTilt to 90. //To start
lock steering to (autoTilt, 90, 0). //(Pitch, Yaw, Roll)
lock throttle to autoThrottle.

switch to 0. //For logging
set startTime to time:seconds. //For logging

until stage:liquidfuel < 5 {
    set dt to 0.05.
    set v_target to pid_loop_alt(body:geopositionOf(ship:position):terrainHeight, altitude). //Updates every physics tick
    if(TIME:SECONDS - lastTime_vel >= dt){ //Updates every 0.1 seconds
        set autoTilt to pid_loop_tilt(vh_target, ship:groundspeed).
        set autoThrottle to pid_loop_vel(v_target, ship:verticalspeed, autoTilt).
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
switch to 1.
