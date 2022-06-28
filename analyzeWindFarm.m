function [ c1, c2, c3, c4, c5 ] = analyzeWindFarm( filenameWind, filenameWave, filenameBuoy, windSpeedMin, windSpeedMax, waveHeightMax, waveHeightRisk, deckHeight )
% Function to complete Task 1. Evaluates the 5 constraints on the location of a
% wind farm.
%
%   parameters: 
%          filenameWind: a string that names the file containing the 
%                        global-model-based average wind speed 
%                        (i.e. 'windSpeedTestCase.csv')
%          filenameWave: a string that names the file containing the 
%                        global-model-based average global wave heights 
%                        (i.e. 'waveHeightTestCase.csv')
%          filenameBuoy: a string that names the file containing the time 
%                        series of wave heights measured by the buoy          
%                        (i.e. 'buoyTestCase.csv')
%          windSpeedMin: for constraint 1 -- minimum wind speed (m/s)
%          windSpeedMax: for constraint 1 -- maximum wind speed (m/s)
%         waveHeightMax: for constraints 2 & 3 -- maximum wave height (m)
%        waveHeightRisk: for constraint 3 -- maximum wave height risk (%)
%            deckHeight: for constraint 4 -- height of the deck that supports 
%                        the turbine base (m)
%
%   return values:
%                    c1: boolean values corresponding to whether the wind 
%                        farm location passes constraint #1
%                    c2: boolean values corresponding to whether the wind 
%                        farm location passes constraint #2
%                    c3: boolean values corresponding to whether the wind 
%                        farm location passes constraint #3
%                    c4: boolean values corresponding to whether the wind 
%                        farm location passes constraint #4
%                    c5: boolean values corresponding to whether the wind 
%                        farm location passes constraint #5

% Reads in the wind and wave file for later use
windValues = csvread (filenameWind);
waveValues = csvread (filenameWave);
% Reads in the buoy file and indexes out all the other information besides
% the latitude and longitude value
coordValues = csvread (filenameBuoy, 1,1, [1 1 1 2]);
% Reads in the buoy file again and indexes only the column of wave heights 
file = csvread (filenameBuoy, 5, 1);
newWaveHeight = file(1:end, 1);

% Sets the latitude and longitude values using the indexed buoy file
latitude  = coordValues (1,1);
longitude = coordValues (1,2);

% Indexes the measured wind values at each specific latitude and longtitude
% coordinate
windSpeed = windValues(latitude, longitude);

% Indexes the measured wave values at each specfic latitude and longitude
% coordinate
waveHeight = waveValues(latitude,longitude);

% Calls the size function to get the total amount of waves that were
% measured
totalCount = size(newWaveHeight,1);

% Finds the waves with a height smaller than the max
smallWaves = waveHeightMax > newWaveHeight;
% Sums the waves that are smaller than the max
total = sum(smallWaves == 1);

% Calculates the total amount of rogue waves, and determines if they are
% less than the deck height
rogueWave = newWaveHeight .* 2;
lowRogueWave = deckHeight > rogueWave;
% Sums the amount of "good" rogue waves
totalRogue = sum(lowRogueWave);

% Calculates the standard deviation of all the wave heights
stdHeight = std(newWaveHeight);

% Calculates all the constraints

% Calculates the first constraint which checks if the wind speed is between
% the max and min
c1 = (windSpeedMax >= windSpeed & windSpeed >= windSpeedMin);

% Calculates the second constraint which checks if the wave height is below
% the max height which is given
c2 = (waveHeightMax > waveHeight);

% Calculates the third constraint which shows of often wave heights are
% less than the max. Returns a percentage
risk = (100.* (total ./ totalCount));
c3 = waveHeightRisk < risk;

% Calculates the fourth constraint which checks to see which rogue waves
% are less than the deck height
c4 = size(rogueWave,1) == totalRogue;

% Calculates the fifth constraint which checks that all the standard
% deviations are less than 5% of the global model average height
c5 = (waveHeight .* 0.05) > stdHeight;









end

