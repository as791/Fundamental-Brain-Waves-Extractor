function [a,b] = filteroption(TypeOfWave,passband_delta,transition_width,Ap,As,Ts)
    switch TypeOfWave
        case "Gamma"
            fc = 31;
            fp = fc+passband_delta;
            fs = fp-transition_width;

            Fp = (2/Ts)*tan((2*pi*fp*Ts)/2);
            Fs = (2/Ts)*tan((2*pi*fs*Ts)/2);
            Fb = [0,0,0,0];

            [a,b] = filterdsp(Ap,As,Fp,Fs,Fb,"HPF",Ts);

        case {"Beta","Alpha","Theta"}
            if TypeOfWave=="Beta"
                fc1 = 14; fc2 = 30;
            elseif TypeOfWave=="Alpha"
                fc1 = 9; fc2 = 13;
            else
                fc1 = 4; fc2 = 8;
            end
            fpl = fc1+passband_delta;
            fpu = fc2-passband_delta;
            fsl = fpl-transition_width;
            fsu = fpu+transition_width;

            Fpl = (2/Ts)*tan((2*pi*fpl*Ts)/2);
            Fpu = (2/Ts)*tan((2*pi*fpu*Ts)/2);
            Fsl = (2/Ts)*tan((2*pi*fsl*Ts)/2);
            Fsu = (2/Ts)*tan((2*pi*fsu*Ts)/2);
            Fc1 = (2/Ts)*tan((2*pi*fc1*Ts)/2);
            Fc2 = (2/Ts)*tan((2*pi*fc2*Ts)/2);

            Fc = sqrt(Fc1*Fc2);
            Fpu1 = Fc^2/Fpl; Wp1 = Fpu1-Fpl;
            Fpl1 = Fc^2/Fpu; Wp2 = Fpu-Fpl1;
            Fsu1 = Fc^2/Fsl; Ws1 = Fsu1-Fsl;
            Fsl1 = Fc^2/Fsu; Ws2 = Fsu-Fsl1;

            if Wp1>Wp2
                Fpl = Fpl1;
            else
                Fpu = Fpu1;
            end

            if Ws1>Ws2
               Fsl = Fsl1;
            else
               Fsu = Fsu1;
            end

            Fb = [Fpu,Fpl,Fsu,Fsl];

            [a,b] = filterdsp(Ap,As,0,0,Fb,"BPF",Ts);


        case "Delta"
            fc = 4;
            fp = fc-passband_delta;
            fs = fp+transition_width;

            Fp = (2/Ts)*tan((2*pi*fp*Ts)/2);
            Fs = (2/Ts)*tan((2*pi*fs*Ts)/2);
            Fb = [0,0,0,0];

            [a,b] = filterdsp(Ap,As,Fp,Fs,Fb,"LPF",Ts);
    end
end

