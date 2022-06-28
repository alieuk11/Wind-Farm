function [  ] = makePlots( filenameWind, filenameWave, filenameBuoy, windSpeedMin, windSpeedMax, waveHeightMax )

% Function to complete Task 2. Creates a figure with multiple plots that 
% summarizes the environmental conditions for a wind farm.  Saves figure as 
% a .png file.
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
%         waveHeightMax: for constraint 2 -- maximum wave height (m)
%
%   return values: none
%
%   notes:
%       Feel free to use different variable names than these if it makes 
%       your code more readable to you.  These are internal to your 
%       function, so it doesn't matter what you call them.

%% Load the data

% Get lat/lon data
lat = csvread('lat.csv');
lon = csvread('lon.csv');




%% Figure Setup

% Set up the figure properties so it will be the correct size
Fig1 = figure(1);
Fig1.Units = 'normalized';
Fig1.OuterPosition = [0 0 0.5 1];

%% Make Plots

% Reads in the wind file so the data can be used in the first subplot
Z = csvread(filenameWind);

% Reads in the wave file so the data can be used in the 2nd subplot
A = csvread(filenameWave);

% Reads in the buoy file and indexes the buoy location
buoyLoc = csvread(filenameBuoy, 1, 1, [1 1 1 2]);
% Reads in the buoy file again but removes the first 5 rows that don't
% contain data
W = csvread(filenameBuoy, 5, 0);

% Creates the first subplot 
subplot(3,2,1);
% Declares variables for the latitude and longitude and uses meshgrid to
% plot them together
x = lon;
y = lat;
[X,Y] = meshgrid(x,y);

% Creates a contour map of the average wind speed against the latitude
% and longitude values
contourf(X,Y,Z, 'LineStyle', 'none');
% Adjusts the map using the provided details from the specifications
ylabel ('latitude (deg)');
xlabel ('longitude (deg)');
title('Average Wind Speed (m/s) Across Planet');
colormap(gca, 'parula');
colorbar
hold on

% Creates the second subplot
subplot(3,2,2);

% Creates another contour map of the average wave height against the
% latitude and longitude
contourf(X,Y,A, 'LineStyle', 'none');
% Adjusts the map using the provided details from the specifications
ylabel ('latitude (deg)');
xlabel ('longitude (deg)');
title('Average Wave Height (m) Across Planet');
colormap(gca, 'parula');
colorbar
hold on

% Creates a third subplot
subplot(3,2,3);

% Find constraints 1 and 2 in order to create the new contour map for
% potential wind farm locations
c1 = (Z >= windSpeedMin & Z <= windSpeedMax);
c2 = waveHeightMax > A;
% Declares a variable that meets both constraints
B = (c1>0 & c2 >0);

% Indexes the latitude and longitude of the buoy
latitude = buoyLoc (1,1);
longitude = buoyLoc (1,2);
latPlot = lat(:,latitude);
lonPlot = lon(:,longitude);

% Creates another contour map of all the potential wind farm locations that
% abide by constraints 1 and 2
contourf(X,Y,B, 'LineStyle', 'none');
hold on
% Adjusts the map using the provided details from the specifications
ylabel ('latitude (deg)');
xlabel ('longitude (deg)');
title ('Potential Wind Farm Locations');
colormap(gca, flipud(gray));
% Marks the location of the buoy using a red square
plot(lonPlot, latPlot, 'rs', 'MarkerSize', 12);
hold on

% Creates a 4th subplot
subplot(3,2,4);

% Gets all the measured wave heights by the buoy
waveHeights = W(1:end,2);
% Creates a histogram of all the measured wave heights
histogram(waveHeights);
% Adjusts the map using the provided details from the specifications
ylabel('number of occurences');
xlabel('wave height (m)');
title('Wave Heights at Buoy Location');
grid on;
hold on

% Creates a 5th subplot
subplot(3,2,[5,6]);

% Indexes the time from the buoy file
time = W(1:end,1);
% Plots the wave heights as a function of time
plot(time, waveHeights);
% Adjusts the map using the provided details from the specifications
ylabel('wave height (m)');
xlabel('time (hours)');
% Plots a horizontal line across a specific wave height
buoyWaveHeight = A(latitude, longitude);
yline(buoyWaveHeight, 'r');
legend ('Buoy Measured', 'Global Average');
grid on

% Saves the figure as a pdf
print(gcf, 'environmentalSummary.pdf');



end

