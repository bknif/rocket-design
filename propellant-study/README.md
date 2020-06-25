# Propellant Study
## About the Code
### Propellant_Study.m 
is a script which provides a framework for evaluating the specific impulse, mass flow, volume flow, chamber temperature, etc. based on an input of required thrust, chamber pressure, and nozzle exit pressure for a range of propellant combinations. The specific equations used to determine the code outputs can be found in the wiki under propellant study. It should be noted that this code requires NASA CEA and REFPROP. As a result, the propellants that can be evaluated are limited to the CEA and REFPROP fluid libraries. If the code takes a while to run, you can reduce N, remove fuel/oxidizers, or change the loop to be run for specific propellant combinations. 
### CEA_CALL.m
is a function which simplifies calling a function which calls CEA. This makes referencing different propellants much easier, but adds run time. This calling method can likely be simplified by increasing the complexity of the main script.
### CEA_CALL_X.inp
is a input or output file that CEA references to output key values such as isp, density, temperature, pressure, etc. 
### CEAL_CALL.mat
is the .mat file for the CEA call. This is the object that is produced from the function which references NASA CEA.
