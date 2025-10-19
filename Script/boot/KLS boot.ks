core:part:getmodule("kOSProcessor"):doevent("Open Terminal").
print "KerBoot initiated.".
set countdown to 5.
until countdown = 0 {
    print countdown.
    wait 1.
    set countdown to countdown - 1.
}
if alt:radar <= 200 {
    runpath("0:/KLS Launch Script.ks"). //Hopefully this stops it from running in orbit...
    //wait 20.
    //runpath("0:/MES.ks"). //Script to execute next manuever node you create.
    //runpath("0:/TMI.ks"). Eventual script to automate transfer to the Mun.
    //runpath("0:/MunarLandingSequence"). Eventual script to automate landing on the Mun.

}
lock throttle to 0.
lock steering to prograde.
SAS on.
print "Thank you for flying with Kerbal Launch System. Have a pleasant flight.".