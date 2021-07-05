function instPowed = instPow(data,fs,w1,w2)

if size(data,1) > size(data,2)
    data = data';
end

fs = round(fs,4);
w1 = round(w1,4);
w2 = round(w2,4);

dogged = DoG(data,fs,w1,w2);
instPowed = zeros(size(data));

for i = 1:min(size(data))
    ripWindow  = pi / mean( [w1 w2] );
    powerWin   = makegausslpfir( 1 / ripWindow, fs, 4 );

    rip        = dogged(i,:);
    rip        = abs(rip);
    ripPower0  = firfilt( rip, powerWin );
    ripPower0  = max(ripPower0,[],2);

    instPowed(i,:) = ripPower0;
end