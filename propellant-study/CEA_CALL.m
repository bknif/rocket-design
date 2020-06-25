function [data_eq] = CEA_CALL(pc,pe,OF,fuel,fuel_temp,fuel_weight,ox,ox_temp,ox_weight)

CEA_RUN = true;
CEA_SAVE_FILE = 'CEA_CALL_.mat';

inp = containers.Map;
inp('type') = 'eq';              % Sets the type of CEA calculation
inp('p') = pc/6895;                % Chamber pressure
inp('pip') = pc/pe;
inp('o/f') = OF;

inp('p_unit') = 'psi';              % Chamber pressure units
inp('fuel') = fuel;             % Fuel name from thermo.inp
inp('fuel_t') = fuel_temp;
inp('fuel_wt%') = fuel_weight;             % Fuel name from thermo.in
inp('ox') = ox;             % Fuel name from thermo.inp
inp('ox_t') = ox_temp;
inp('ox_wt%') = ox_weight;             % Fuel name from thermo.in
inp('file_name') = 'CEA_CALL_.inp';    % Input/output file name

if CEA_RUN
    data = cea_rocket_run(inp);     % Call the CEA MATLAB code
    save(CEA_SAVE_FILE, 'data');
else
    load(CEA_SAVE_FILE);
end

data_eq = data('eq');

end

