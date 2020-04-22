set N;   # set of cities
param lat{N};   # cities' latitude
param lng{N};   # cities' longitude
param pop{N};   # cities' population

# constants
param R := 6371.009;   # earth radius
param c{i in N} := ceil(pop[i] * 3 / 1000);
param pi := 3.14159265359;
param DC := 1;
param DCost := 25000;


# main variables: 
var dc_to_build >=1, <= 5;

var dc_lat{dc_to_build};   # distribution center's latitude
var dc_lng{dc_to_build};   # distribution center's longitude

# auxiliary variables:
var dlat{N} >= 0;   # L1 distance component in latitude
var dlng{N} >= 0;   # L1 distance component in longitude
var d{N} >= 0;   # L1 distance (sum of lat + lng components)
var DTotalCost;

minimize tcost: sum {i in N} c[i] * d[i] + DTotalCost; 

subject to

latA {i in N, j in 1 .. dc_to_build}: dlat[i,j] >= 2 * pi * R * (dc_lat[j]-lat[i])/360;
latB {i in N, j in 1 .. dc_to_build}: dlat[i,j] >= 2 * pi * R * (lat[i]-dc_lat[j])/360;
lngA {i in N, j in 1 .. dc_to_build}: dlng[i,j] >= 2 * pi * R * (dc_lng[j]-lng[i])/360;
lngB {i in N, j in 1 .. dc_to_build}: dlng[i,j] >= 2 * pi * R * (lng[i]-dc_lng[j])/360;
dist {i in N}: d[i] = sum {j in 1 .. dc_to_build} dlat[i,j] + dlng[i,j];
buildcost: DTotalCost = DC * DCost;
totaldc_lower: dc_to_build >= 1;
totaldc_upper: dc_to_build <= 5;

solve;

printf "\n";
printf "*** minimizing total distance\n";
printf "Location of the DC: %g, %g \n",  dc_lat, dc_lng;
printf "DC cost: %g euros\n",  DTotalCost;
printf "Total cost: %.8g euros\n", tcost;
printf "Town closest to DC:   ";
printf {j in N: d[j] = min {i in N} d[i]} j;
printf "\n";
printf "Town with largest distributions costs:   ";
printf {j in N: c[j]*d[j] = max {i in N} c[i]*d[i]} j;
printf "\n";


end;