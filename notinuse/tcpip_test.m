function tcpip_test
signal = 1;

t = tcpip('169.254.225.16', 30000, 'NetworkRole', 'client');
fopen(t);

fwrite(t, signal);