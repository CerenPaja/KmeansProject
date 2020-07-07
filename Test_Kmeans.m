% simplified example -convert uint16 to double
 
variable = stats2(2).PixelValues;
val = double(variable);
 
%% This creates new field in stats2 struct, fills it with double version of PixelValues

for k = 1 : length(stats2);
    stats2(k).Doubles = double(stats2(k).PixelValues);
end
%% This creates new field for std values
for z = 1 : length(stats2);
    stats2(z).Std_vals = std(stats2(z).Doubles);
end

%% Create dot ids
for z = 1: length(stats2);
    stats2(z).Dotids = z;
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

%% Plot std vs mean intensity and color by cluster groups
group = TestMatrix(:,4);
gscatter(TestMatrix(:,3),TestMatrix(:,2),group);



%% We force MeanIntensity values to be in a range between o to 1+eps
% WE DONT USE THIS YET

[c,x] = ecdf(TestMatrix(:,3));                    % normalizing MeanIntensity Distribution
most_vals = find(c>.99,1,'first');                 % take 99 percent of the distribution
mI = TestMatrix(:,3)-min(TestMatrix(:,3))+eps;     % calculate the mean intensity 
mI = mI/x(most_vals)-eps/2;    

% save this mI result as the 5th column of our TestMatrix
TestMatrix(:,5) = mI;




