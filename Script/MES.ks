//Manuever Execution System: Guidance system for automated manuever nodes.
//runpath("0:/MES.ks"). 

function main{
    SAS off.
    createNode().
    //addToFlightPlan(mnv).
    calculateStartTime(mnv).
    executeManuever(mnv).
    isManueverComplete(mnv).
    if false {
        print "Manuever Execution system failed. Please try again.".
        SAS on.
        abort.
    } else {
        ManueverComplete(mnv).
        print "Manuever Execution System ending. Pilot has control.".
    }
    SAS on.
}
function createNode {
        declare global mnv to NEXTNODE. //whatever node you make in game should be automatically added to this.
        // parameter time, heading. Timespan is ETA to node (year,day,hour,minute,second)
    }
// function addToFlightPlan {
//         parameter mnv.
//         add mnv.
//     }
function calculateStartTime {
    parameter mnv.
    local isp is 0.
    list engines in myEngines.
    for engine in myEngines {
        if engine:ignition and not engine:flameout {
            set isp to isp + (engine:isp * (engine:availablethrust / ship:availablethrust)). //takes weighted average of ISP available based on how many engines are active at the time.
        }
    }
    local g0 is 9.81. //constant
    local dV is mnv:deltaV:MAG. //magnitude of burnVector from node mnv.
    local fuelFlow is ship:availablethrust/(isp*g0).
    local mf is ship:mass/(constant:e^(dV/(isp*g0))).
    global t is (ship:mass-mf)/fuelFlow. //outputs seconds
    global startTime is (time:seconds + mnv:ETA - t/2). //need to make sure time is accurate (i.e. burntime is in seconds and startime is in seconds), WIP.
    // dV = isp * g0 * ln(m0/mf)
    // mf = m0 - (fuelFlow * t)
    // F = isp * g0 * fuelFlow 
    print "Manuever deltaV: " + dV.
    print "Estimated Burn Time: " + t.
    print "Estimated Start Time: " + startTime.
    print "ETA Time: " + mnv:ETA.
}
function executeManuever {
        parameter mnv. //takes in the manuever node we created in createNode.
        lock steering to mnv:burnvector. //whatever vector mnv gives us.
        wait until time:seconds > startTime.  //not working exactly right...
        lock throttle to 1.  //start initial burn
        until mnv:deltaV:MAG < 3 {
            if mnv:deltaV:MAG <= 50 and mnv:deltaV:MAG > 15 {
            lock throttle to .25.
            }
            if mnv:deltaV:MAG <= 15 {
            lock throttle to .1.
            }
        }
        lock throttle to 0.
}
function isManueverComplete {
        parameter mnv.
        if not(defined burnVector) {declare global burnVector to mnv:burnVector.}
        if vang(burnVector,mnv:burnvector) > 10 {
            print "Manuever complete.".
            print "Angle: " + vang(burnVector,mnv:burnVector).
            return true.
        }
        else {
            return false.
        }
        //function to check if the manuever is complete, probably best accomplished by checking the angle between
        // the original burnvector and the manuever node's current vector.
        
    }
function manueverComplete {
        parameter mnv.
        //if conditions are all met, return true to complete the function
        remove mnv.
        return true.
    }
main(). 