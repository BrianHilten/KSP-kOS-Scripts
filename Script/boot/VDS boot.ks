core:part:getmodule("kOSProcessor"):doevent("Open Terminal").
print "Kerboot initiated.".
set countdown to 5.
until countdown = 0 {
    print countdown.
    wait 1.
    set countdown to countdown - 1.
}
print "Executing Landing Sequence.".
runpath("0:/P63.ks").
print "Landing sequence completed. Happy exploring!".
