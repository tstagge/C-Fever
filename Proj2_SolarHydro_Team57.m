% PROJECT 2: HYDROELECTRIC ENERGY STORAGE SYSTEM MODEL
% File:    Proj2_SolarHydro_Team57.m
% Date:    31 March 2016
% By:      Jillian Hestle [jhestle]
%          Emily Schott [eschott]
%          Tyler Stagge [tstagge]
%          Nicholas Vilbrandt [nvilbran]
% Section  04
% Team:    57
%
% ELECTRONIC SIGNATURE
% Jillian Hestle
% Emily Schott
% Tyler Stagge
% Nicholas Vilbrandt
%
% The electronic signatures above indicate that the program     
% submitted for evaluation is the combined effort of all   
% team members and that each member of the team was an     
% equal participant in its creation.  In addition, each 
% member of the team has a general understanding of                  
% all aspects of the program development and execution.  
%
% This script allows access to both the manual, case-specifc version and
% the automatic, optimization version of the model.

%% CLEAR COMMANDS
clc;
clear;

%% INPUT
printDoubleLine();
fprintf('     Solar Hydroelectric Energy Storage System Model     \n');
fprintf('                         Team 57                         \n');
printLine();
fprintf('Please select desired version\n');
fprintf('\t1 : Manual (Case-Specific) Model\n');
fprintf('\t2 : Automatic (Optimization) Model\n');
fprintf('\t0 : EXIT\n');
selectionNumber = input('Enter menu number: ');

%% MODEL EXECUTION
switch(selectionNumber)
    case 1
        printDoubleLine();
        ManualDriver;
    case 2
        printDoubleLine();
        OptimizationDriver;
    otherwise
        fprintf('\nPROGRAM TERMINATED\n');
        printDoubleLine();
end

