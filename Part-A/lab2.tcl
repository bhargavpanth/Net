set ns [new Simulator]
set tf [open lab2.tr w]
$ns trace-all $tf
set nf [open lab2.nam w]
$ns namtrace-all $nf

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]


$ns color 1 "red" 
$ns color 2 "blue"

$n0 label "Source/TCP" 
$n1 label "Source/UDP" 
$n2 label "Router"
$n3 label "Destination/Null"

$ns duplex-link $n0 $n2 1Mb 2ms DropTail
$ns duplex-link $n1 $n2 5Mb 2ms DropTail
$ns duplex-link $n2 $n3 1.5Mb 10ms DropTail



set udp1 [new Agent/UDP]
$ns attach-agent $n1 $udp1
set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp1

set null3 [new Agent/Null]
$ns attach-agent $n3 $null3

$ns connect $udp1 $null3


set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0

set sink3 [new Agent/TCPSink]
$ns attach-agent $n3 $sink3

$ns connect $tcp0 $sink3

$ns at 1.1 "$cbr1 start"
$ns at 1.2 "$ftp0 start"
$ns at 10.0 "finish"

#The below code sets the udp0 packets to red and udp1 #packets to blue color

$udp1 set class_ 1
$tcp  set class_ 2

proc finish {} {
	global ns tf nf
	$ns flush-trace
	close $tf
	close $nf

	puts "running nam..."
	puts "TCP PACKETS.."
	puts "UDP PACKETS.."
	
	exec nam lab2.nam &
	exit 0
}

$ns run

