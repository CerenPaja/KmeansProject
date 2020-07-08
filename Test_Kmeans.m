% simplified example -convert uint16 to double
 
variable = stats2(2).PixelValues;
val = double(variable);
 
%% This creates new field in stats2 struct, fills it with double version of PixelValues

for k = 1 : length(stats2)
    stats2(k).Doubles = double(stats2(k).PixelValues);
end
%% This creates new field for std values
for z = 1 : length(stats2)
    stats2(z).Std_vals = std(stats2(z).Doubles);
end

%% Create dot ids
for z = 1: length(stats2)
    stats2(z).Dotids = z;
end

%% Sum of pixels 

for z = 1: length(stats2)
    stats2(z).SumPixel = sum(stats2(z).Doubles);
end


%% TEST example with random data

a = randi(255,10,3);
a(:,4) = kmeans(a(:,1:2),6);

%% we need to save field as column into new matrix

TestMatrix(:,1)= (extractfield(stats2, 'Dotids'))';       %1st column
TestMatrix(:,2)= (extractfield(stats2, 'Std_vals'))';     %2nd column
TestMatrix(:,3)= (extractfield(stats2, 'MeanIntensity'))'; %3rd column

%% Apply kmeans algorithm and save it to 4th column

TestMatrix(:,4)= kmeans(TestMatrix(:,2:3),6);

%% Custom made color map for plots
cmp(1,:) = [0.8,0,0];% red
cmp(2,:) = [0.9,0.6,0];%orange
cmp(3,:) = [1,0.9,0];%yellow
cmp(4,:) = [0.3,0.8,1];%cyan
cmp(5,:) = [0,0.1,1];%dark blue
cmp(6,:) = [0.8,0.2,1];%magenta

%% Plot std vs mean intensity and color by cluster groups

group = TestMatrix(:,4);
gscatter(TestMatrix(:,3),TestMatrix(:,2),group,cmp);
xlabel('Mean Intensity') 
ylabel('Standart deviation Intensity')


%% We force MeanIntensity values to be in a range between o to 1+eps
% WE DONT USE THIS
% YET.................................................................

[c,x] = ecdf(TestMatrix(:,3));                    % normalizing MeanIntensity Distribution
most_vals = find(c>.99,1,'first');                 % take 99 percent of the distribution
mI = TestMatrix(:,3)-min(TestMatrix(:,3))+eps;     % calculate the mean intensity 
mI = mI/x(most_vals)-eps/2;    

% save this mI result as the 5th column of our TestMatrix
TestMatrix(:,5) = mI;

%% Visualize the clusters
% we need tmp_shift file for this (drag it into command window)

%first create ind variable = selected cluster groups and their dot ids
ind = TestMatrix((group > 2), :);
ind = ind(:,1);

%% Another way of choosing clusters
ind = TestMatrix((group == 6), :);
ind = ind(:,1);

%% Create this variable for easy visualization
DotCentre        = cat(1,stats2.Centroid);
%% Visualization of the clusters
figure
imshow(max(tmp_shift,[],3),[])               
hold on 
plot(DotCentre(:,1),DotCentre(:,2),'b.')     
plot(DotCentre(ind,1),DotCentre(ind,2),'r.')






