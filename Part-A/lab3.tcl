set ns [new Simulator]

set tf [open lab3.tr w]
$ns trace-all $tf
set nf [open lab3.nam w]
$ns namtrace-all $nf

proc finish {} {
	global ns tf nf
	$ns flush-trace
	close $tf
	close $nf

	puts "running nam..."
	exec nam lab3.nam &
	exit 0
}

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

$ns color 1 "red" 
$ns color 2 "green"
$ns color 3 "blue"

$ns duplex-link $n0 $n1 0.01Mb 10ms DropTail
$ns duplex-link $n1 $n2 0.01Mb 10ms DropTail
$ns duplex-link $n2 $n3 0.01Mb 10ms DropTail
$ns duplex-link $n3 $n4 0.01Mb 10ms DropTail
$ns duplex-link $n4 $n5 0.01Mb 10ms DropTail
$ns duplex-link $n0 $n5 0.01Mb 10ms DropTail
$ns duplex-link $n1 $n3 0.01Mb 10ms DropTail

#The below function is executed when the ping agent receives a reply from the destination
Agent/Ping instproc recv {from rtt} {
 $self instvar node_
 puts "node [$node_ id] received ping answer from $from with round-trip-time $rtt ms."
}

set p(0) [new Agent/Ping]
$ns attach-agent $n0 $p(0)

set p(1) [new Agent/Ping]
$ns attach-agent $n2 $p(1)

set p(2) [new Agent/Ping]
$ns attach-agent $n2 $p(2)

set p(3) [new Agent/Ping]
$ns attach-agent $n3 $p(3)

set p(4) [new Agent/Ping]
$ns attach-agent $n4 $p(4)

set p(5) [new Agent/Ping]
$ns attach-agent $n5 $p(5)

$ns connect $p(0) $p(1)
$ns connect $p(1) $p(2)
$ns connect $p(2) $p(3)
$ns connect $p(3) $p(4)
$ns connect $p(4) $p(5)
$ns connect $p(5) $p(0)
$ns connect $p(0) $p(2)
$ns connect $p(0) $p(3)
$ns connect $p(0) $p(4)

$p(0) set class_ 1

$p(5) set class_ 2

$p(3) set class_ 3


for {set i 0} {$i < 50 } {incr i} {
$ns at 0.2 "$p(0) send"
$ns at 0.2 "$p(1) send"
$ns at 0.2 "$p(2) send"
$ns at 0.2 "$p(3) send"
$ns at 0.2 "$p(4) send"
$ns at 0.2 "$p(5) send"
}
$ns at 1.0 "finish"

$ns run
