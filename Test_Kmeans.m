% simplified example - convert uint16 to double 
 
%variable = stats2(2).PixelValues;  %this is just for 2nd row
%val = double(variable);
 
%% This creates new field in stats2 struct, fills it with double version of PixelValues = Doubles
for k = 1 : length(stats2)
    stats2(k).Doubles = double(stats2(k).PixelValues);
end

% This creates new field for std values = Std_vals
for z = 1 : length(stats2)
    stats2(z).Std_vals = std(stats2(z).Doubles);
end

% Create Dot ids
for z = 1: length(stats2)
    stats2(z).Dotids = z;
end

%% Sum of pixels = SumPixel (add this if necessary)
for z = 1: length(stats2)
    stats2(z).SumPixel = sum(stats2(z).Doubles);
end

%% Medin of pixels = MedianVal (add this if necessary)
for z = 1: length(stats2)
    stats2(z).MedianVal = median(stats2(z).Doubles);
end

%% Here we take these each fields and save them as column into new matrix call it TestMatrix
% it is important to know which column corresponds to which field we save,
% later when we do calculations or plotting

TestMatrix(:,1) = (extractfield(stats2, 'Dotids'))';        %1st column
TestMatrix(:,2) = (extractfield(stats2, 'Std_vals'))';      %2nd column   
TestMatrix(:,3) = (extractfield(stats2, 'MeanIntensity'))'; %3rd column
%TestMatrix(:,4) = (extractfield(stats2, 'SumPixel'))';     %4th column
%TestMatrix(:,6) = (extractfield(stats2, 'Area'))';          %4th column
%TestMatrix(:,5) = (extractfield(stats2, 'SumPixel'))';      %5th column

%% We force MeanIntensity values to be in a range between o to 1+eps
% WE DONT USE THIS
% YET.................................................................

[c,x] = ecdf(TestMatrix(:,3));                    % normalizing MeanIntensity Distribution
most_vals = find(c>.99,1,'first');                 % take 99 percent of the distribution
mI = TestMatrix(:,3)-min(TestMatrix(:,3))+eps;     % calculate the mean intensity 
mI = mI/x(most_vals)-eps/2;    

% save this mI result as the 7th column of our TestMatrix

TestMatrix(:,4) = mI;  % or dont run this if you dont need this variable

%% Apply kmeans algorithm to ==> 2 different parameters
% when we write (:,2:3) means we use 2nd and 3rd column to calculate kmeans
rng('default')
TestMatrix(:,4)= kmeans(TestMatrix(:,2:3),6);

%% Calculate kmeans from Mean Intensity ONLY
rng('default')
TestMatrix(:,4)= kmeans(TestMatrix(:,3),6);

%% Custom made color map for plots
cmp(1,:) = [0.8,0,0];% red
cmp(2,:) = [0.9,0.6,0];%orange
cmp(3,:) = [1,0.9,0];%yellow
cmp(4,:) = [0.3,0.8,1];%cyan
cmp(5,:) = [0,0.1,1];%dark blue
cmp(6,:) = [0.8,0.2,1];%magenta

%% Plot std vs mean intensity and color by cluster groups

group = TestMatrix(:,4);  % this is the kmeans cluster groups whic we saved to 6th column
gscatter(TestMatrix(:,3),TestMatrix(:,2),group,cmp);
xlabel('Mean Intensity') 
ylabel('Std Intensity')

%% SELECTING CLUSTER GROUPS FOR VISUALIZATION
% first create ind variable = selected cluster groups and their dot ids
ind = TestMatrix((group > 1),:); 
ind = ind(:,1);

%% Another way of choosing clusters (this selects only one group)
ind = TestMatrix((group == 4), :);
ind = ind(:,1);

%% Another way of choosing clusters (this selects as many groups as you want)
ind1 = TestMatrix((group == 2), :);
ind2 = TestMatrix((group == 4), :);
ind3 = TestMatrix((group == 5), :);
%ind4 = TestMatrix((group == 5), :);

ind1 = ind1(:,1);
ind2 = ind2(:,1);
ind3 = ind3(:,1);
%ind4 = ind4(:,1);
%
ind = cat(1,ind1,ind2);
ind = cat(1,ind,ind3);
%ind = cat(1,ind,ind4);
%% Create this variable for easy visualization
DotCentre        = cat(1,stats2.Centroid);

%% Visualization of the clusters

% we need tmp_shift file for this (drag it into command window)

figure
imshow(max(tmp_shift,[],3),[])               
hold on 
plot(DotCentre(:,1),DotCentre(:,2),'b.')     
plot(DotCentre(ind,1),DotCentre(ind,2),'r.')
