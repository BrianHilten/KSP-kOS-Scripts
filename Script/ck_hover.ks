//Code adapted from CheersKevin tutorial on youtube

//k values:
set kP to 0.01.
set kI to 0.0005. //Suffers from integral windup
set kD to 0.005.

//set dt to 0.001.
set pid_output to 0.
set lastP to 0.
set totalP to 0.
set lastTime to 0.

function pid_loop {
    parameter target
    parameter current

    set currentTime to time:seconds.

    set P to (target-current). //Our proportional gain based off of current error

    if(lastTime > 0){
        set I to totalP + (P + lastP)/2 * (currentTime-lastTime). //Our accumulated error (area under "curve" created by data points over time)
        set D to (P - lastP) / (currentTime-lastTime). //Our rate of change (slope of line between two consecutive data points)
    }
    else{
        set I to 0.
        set D to 0.
    }
    
    //Update for next loop:
    set lastTime to currentTime.
    set lastP to P.
    set totalP to I. 

    set pid_output to P*kP + I*kI + D*kD.

    //Print results to console for tracking
    CLEARSCREEN:
    print "P: " + P.
    print "I: " + I.
    print "D: " to D.
    print "Throttle: " + pid_output.

    return pid_output.
}

lock steering to heading (90,90).
set autoThrottle to 0.
//lock throttle to 0.2.
stage.
//wait until altitude > 500.

//Test p_loop
lock throttle to autoThrottle.

switch to 0.
set startTime to time:seconds. //for logging
set target to 500. //Our target altitude

until stage:liquidfuel < 5 {
    set autoThrottle to pid_loop(target, altitude). //Use our PID function to set throttle value
    set autoThrottle to max(0, min(autoThrottle, 1)). //To ensure throttle gets a value 0 <-> 1
    log(time:seconds - startTime) + "," + altitude + "," + autoThrottle to "p_loop.csv".
    wait 0.001. //To (hopefully) not blow up kOS CPU
}

//recover
lock throttle to 0.
stage. //deploy recovery chutes.
switch to 1.