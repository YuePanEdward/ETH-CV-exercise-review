% calculate arbitary logs
function y=logn(x,n)
if x==0 | n==0
    disp('warning:log of zero!');
    y=NaN;
elseif n==1
    disp('error:n==1');
else
    if x<0 | n<0
        disp('warning:the result will be imaginary!');
    end
    switch n
        case exp(1)
            y=log(x);
        case 2
            y=log2(x);
        case 10
            y=log10(x);
        otherwise
            y=log(x)/log(n);
    end
end