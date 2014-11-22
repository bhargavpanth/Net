set ns [new Simulator] 
set tf [open lab4.tr w]

$ns trace-all $tf
set nf [open lab4.nam w] 
$ns namtrace-all $nf

set n0 [$ns node] 
set n1 [$ns node] 
set n2 [$ns node] 
set n3 [$ns node] 
set n4 [$ns node] 
set n5 [$ns node] 
set n6 [$ns node]

$ns color 1 "red" 
$ns color 2 "green"
$ns color 3 "blue"

$n1 label "Source" 
$n2 label "Error Node"

$n5 label "Destination"

$n1 set class_ 1

$n2 set class_ 2

$n6 set class_ 3

#The below code is used to
#create a two Lans (Lan1 and #Lan2).
$ns make-lan "$n0 $n1 $n2 $n3" 10Mb 10ms LL Queue/DropTail Mac/802_3
$ns make-lan "$n4 $n5 $n6" 10Mb 10ms LL Queue/DropTail Mac/802_3

# connect node n2 and n6

$ns duplex-link $n2 $n6 10Mb 100ms DropTail 
set udp0 [new Agent/UDP]

$ns attach-agent $n1 $udp0

set cbr0 [ new Application/Traffic/CBR] 
$cbr0 attach-agent $udp0

set null5 [new Agent/Null] 
$ns attach-agent $n5 $null5 
$ns connect $udp0 $null5 
$cbr0 set packetSize_ 100 
$cbr0 set interval_ 0.1 
$udp0 set class_ 1

# The below code is used to add an error model between the nodes n2 and n6.

set err [new ErrorModel] 
$ns lossmodel $err $n2 $n6

#inserting the error rate 
$err set rate_ 0.002

proc finish { } { 
global nf ns tf 
exec nam lab4.nam & 
close $nf

close $tf exit 0

}



$ns at 6.0 "finish"

$ns at 0.1 "$cbr0 start" 
$ns run
