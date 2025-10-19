core:part:getmodule("kOSProcessor"):doevent("Open Terminal").
print "KerBoot initiated.".
set countdown to 5.
until countdown = 0 {
    print countdown.
    wait 1.
    set countdown to countdown - 1.
}
runpath("0:/Aphrodite 2 Launch.ks").