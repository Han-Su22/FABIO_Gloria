%Enable parallel! 15 min for each year with 6 processor in parallel (Matlab 2022b)
%path: fabio-hybrid-master\FABIO_Gloria
for year=1990:2020
    datetime("now")
    disp("Calculate for the year")
    year

    B = readmatrix(strcat('.\gloria\EEMRIO\',num2str(year),'_B.csv'));
    D = readmatrix(strcat('.\gloria\EEMRIO\',num2str(year),'_D.csv'));
    A = B * D;              
    A(isinf(A)|isnan(A)) = 0;
    clear B D;
    
    x = readmatrix(strcat('.\gloria\EEMRIO\',num2str(year),'_x.csv'));
    Z = transpose(x.*transpose(A));
    Z(isinf(Z)|isnan(Z)) = 0;

    %A_r = readmatrix(strcat('E:\fabio-hybrid-master\gloria\EEMRIO\',num2str(year),'_A.csv'));%from R, previously
    %diff_A=abs(A_r-A);
    %max(max(diff_A))
    %Z_r = readmatrix(strcat('E:\fabio-hybrid-master\gloria\EEMRIO\',num2str(year),'_Z.csv'));%from R, previously
    %diff_Z=abs(Z_r-Z);
    %max(max(diff_Z))

    writematrix(A,strcat('.\gloria\EEMRIO\',num2str(year),'_A.csv'));
    writematrix(Z,strcat('.\gloria\EEMRIO\',num2str(year),'_Z.csv'));
    clear Z;

    [n,m]=size(A);
    I = eye(n);
    
    try
        L=inv(I-A);
        writematrix(L,strcat('.\gloria\EEMRIO\',num2str(year),'_L.csv'));
        
        disp("Sum of orginal production")
        sum(x)

        disp("Sum of production when using L")
        Y = readmatrix(strcat('.\gloria\EEMRIO\',num2str(year),'_Y.csv'));
        sum(L * sum(Y,2))

        clear L x Y;

    catch
        warning('Fail to get Leontied inverse');
        year
    end
    clear A;
end

%L_r = readmatrix('E:\fabio-hybrid-master\gloria\EEMRIO\1990_L.csv');