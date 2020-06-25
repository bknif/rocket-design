%% Pathing
% add the CEA and REFPROP to the current folder, here is an example
addpath('E:\Rocket Design\Propellant Selection\CEA')
addpath('E:\Rocket Design\Propellant Selection\refprop')
addpath('E:\Rocket Design\Propellant Selection\refprop\REFPROP')
clear all; clc; close all;

%% Main
% Variables:
% pc: chamber pressure
% pe: exit pressure
% N: number of points for mixture ratio
% OF: mixture ratio
% T: desired thrust
% fuel: fuel name
% ox: ox name
% fuel_temp: fuel temperature
% ox_temp: oxidizer temperature
% fuel_weight: percentage of fuel species (out of 100)
% ox_weight: percentage of ox species (out of 100)
% fuel_density: density of the fuel
% ox_density: density of the oxidizer
% isp_temp: temp. array for specific impulse
% isp: specific impulse
% max_isp: maximum impulse across mixture ratio
% index: index at which the maximum impulse occurs
% opt_OF: the mixture ratio corrosponding to the maximum impulse
% temp_temp: temperature temp. array
% temp: temperature array
% opt_temp: temperature corrosponding to the maximum impulse
% mdot: total mass flow
% ox_mdot: oxidizer mass flow
% fuel_mdot: fuel mass flow
% vdot: volume flow
% fuel_vdot: fuel volume flow
% ox_vdot: oxidizer volume flow


pc = 1500; %[psi]
pe = 14.7; %[psi]
N = 50;
OF = linspace(1,10,N);
T = 20000*4.448; %N

for n = 1:5
    
    % fuels
    switch n
        case 1
            fuel = {'CH4'};
            fuel_temp = [298];
            fuel_weight = [100];
            fuel_density = refpropm('D','T',fuel_temp,'P',pc*6.895,'methane');
        case 2
            fuel = {'CH4(L)'};
            fuel_temp = [110];
            fuel_weight = [100];
            fuel_density = refpropm('D','T',fuel_temp,'P',pc*6.895,'methane');
        case 3
            fuel = {'H2'};
            fuel_temp = [298];
            fuel_weight = [100];
            fuel_density = refpropm('D','T',fuel_temp,'P',pc*6.895,'hydrogen');
        case 4
            fuel = {'H2(L)'};
            fuel_temp = [30];
            fuel_weight = [100];
            fuel_density = refpropm('D','T',fuel_temp,'P',pc*6.895,'hydrogen');
        case 5
            fuel = {'C2H5OH(L)'};
            fuel_temp = [298];
            fuel_weight = [100];
            fuel_density = refpropm('D','T',fuel_temp,'P',pc*6.895,'ethanol');
    end
    
    for k = 1:3
        
        % oxidizer
        switch k
            case 1
                ox = {'O2'};
                ox_temp = [298];
                ox_weight = [100];
                ox_density = refpropm('D','T',ox_temp,'P',pc*6.895,'oxygen');
            case 2
                ox = {'O2(L)'};
                ox_temp = [90];
                ox_weight = [100];
                ox_density = refpropm('D','T',ox_temp,'P',pc*6.895,'oxygen');
            case 3
                ox = {'H2O2(L)'};
                ox_temp = [298];
                ox_weight = [100];
                ox_density = refpropm('D','T',ox_temp,'P',pc*6.895,'h2o2');
        end
        
        % CEA and important data
        data_eq = CEA_CALL(pc,pe,OF,fuel,fuel_temp,fuel_weight,ox,ox_temp,ox_weight);
        
        % determines the isp, mass flow, volume flow, and max temperature
        % of the chamber.
        isp_temp = squeeze(data_eq('isp'));
        isp(:,k) = isp_temp(:,2)./9.8;
        max_isp(n,k) = max(isp(:,k));
        index = find(max_isp(n,k)==isp(:,k));
        opt_OF(n,k) = OF(index);
        temp_temp = squeeze(data_eq('t'));
        temp(:,k) = temp_temp(:,1);
        opt_temp(n,k) = temp(index,k);
        
        mdot(n,k) = T/(9.8*max_isp(n,k)); %[kg/s]
        ox_mdot(n,k) = (opt_OF(n,k)/(1+opt_OF(n,k)))*mdot(n,k); %[kg/s]
        fuel_mdot(n,k) = mdot(n,k)-ox_mdot(n,k); %[kg/s]
        ox_vdot(n,k) = ox_mdot(n,k)/ox_density; %[m^3/s]
        fuel_vdot(n,k) = fuel_mdot(n,k)/fuel_density; %[m^3/s]
        vdot(n,k) = ox_vdot(n,k)+fuel_vdot(n,k); %[m^3/s]
        
        
        figure(n)
        hold on
        grid on
        title(fuel)
        plot(OF,isp(:,k),'DisplayName',string(ox))
        legend;
        xlabel('OF')
        ylabel('isp (s)')
        
        fprintf('\nFuel: %s \nOxidizer: %s \n',string(fuel),string(ox))
        fprintf('\nSpecific Impulse (s): %.1f \n',max_isp(n,k));
        fprintf('\nTotal Mass Flow (kg/s): %.1f \n',mdot(n,k));
        fprintf('\nTotal Volume Flow (m^3/s): %.4f \n',vdot(n,k));
        fprintf('\nFuel Mass Flow (kg/s): %.1f \n',fuel_mdot(n,k));
        fprintf('\nOxidizer Mass Flow (kg/s): %.1f \n',ox_mdot(n,k));
        fprintf('\nFuel Volume Flow (m^3/s): %.4f \n',fuel_vdot(n,k));
        fprintf('\nOxidizer Volume Flow (m^3/s): %.4f \n',ox_vdot(n,k));
        
    end
    
    
end

