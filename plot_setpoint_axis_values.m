function [SP] = plot_setpoint_axis_values(t,TemperatureControl)
n=1;
k=1;
% Creating reactor setpoint temperature
    for D = 1:TemperatureControl.NumChanges
    if D == 1
    SP.y(k) = TemperatureControl.ReactorSetPoint(D);
    k=k+1;
    SP.y(k)= TemperatureControl.ReactorSetPoint(D);
    k=k+1;
    SP.t(n) = 0;
    n = n+1;
    SP.t(n) = TemperatureControl.Time(D+1)-1;
    n = n+1;
   
   elseif D ==  TemperatureControl.NumChanges
    SP.y(k) = TemperatureControl.ReactorSetPoint(D);
    k=k+1;
    SP.y(k)= TemperatureControl.ReactorSetPoint(D);
    k=k+1;
    SP.t(n) = TemperatureControl.Time(D);
    n = n+1;
    SP.t(n) = max(t);
    n = n+1;
   else
     SP.y(k) = TemperatureControl.ReactorSetPoint(D);
     k=k+1;
     SP.y(k)= TemperatureControl.ReactorSetPoint(D);
     k=k+1;
     SP.t(n) = TemperatureControl.Time(D);
     n = n+1;
     SP.t(n) = TemperatureControl.Time(D+1)-1;
     n = n+1;
    end
end 
end