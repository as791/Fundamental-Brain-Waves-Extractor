function  [a,b]= filterdsp(Ap,As,Fp,Fs,F_b,Filter_type,Ts)
%% Required Filter Design of LPF Prototype %%
    if Filter_type == "LPF"
        gamma = Fs/Fp;
    elseif Filter_type == "HPF"
        gamma = Fp/Fs;
    else
        Wp = F_b(1)-F_b(2);
        Ws = F_b(3)-F_b(4);
        if Filter_type == "BPF"
            gamma = Ws/Wp;
        else 
            gamma = Wp/Ws;
        end
    end
    n = acosh(sqrt(10^(0.1*As)-1)/sqrt(10^(0.1*Ap)-1))/acosh(gamma);
    N = ceil(n);
    epsilon = sqrt(10^(0.1*Ap)-1);
    k = 1:1:N;
    xk = (2*k-1)*pi/(2*N);
    y = -asinh(1/epsilon)/N;
    Pole =(1i*cos(xk)*cosh(y)+sin(xk)*sinh(y));
    
    %% Prototype Conversions from LPF to any of the four filters %% 
    s = tf('s');
    if Filter_type == "LPF"
        Fc = Fp*cosh(acosh(1/epsilon)/N);
        s = s/Fc;
    elseif Filter_type == "HPF"
        Fc = Fp*cos(acos(1/epsilon)/N);
        s = Fc/s;
    else
        Wp = F_b(1)-F_b(2);
        Fc = sqrt(F_b(1)*F_b(2));
        if Filter_type == "BPF"
            s = (s^2 + Fc^2)/(Wp*s);
        else 
            s = (Wp*s)/(s^2 + Fc^2);
        end
    end
    %% Chebyshev Polynomial Calculation for the final transfer equation %%
    chebyshev_poly=1;
    for i=1:N
        chebyshev_poly = (1-s/Pole(i))*chebyshev_poly;
    end
    G=1;
    if ~mod(N,2)
        G=1/(1+epsilon^2);
    end
    Ha = G/chebyshev_poly; %analog TF
    Hd = c2d(Ha,Ts,'tustin'); %digital TF
    [b,a] = tfdata(Hd,'v'); %forward and backward coef extraction
end