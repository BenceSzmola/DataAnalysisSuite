function [out1,out2,out3,out4]=testfunctione(in1,in2,in3)

if nargout == 2
    out1 = in1*in2;
    out2 = in2*in3;
elseif nargout == 4
    out1 = in1*in2;
    out2 = in2*in3;
    out3 = in3*in3;
    out4 = 1;
end