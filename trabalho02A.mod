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
var dc_lat;   # distribution center's latitude
var dc_lng;   # distribution center's longitude

# auxiliary variables:
var dlat{N} >= 0;   # L1 distance component in latitude
var dlng{N} >= 0;   # L1 distance component in longitude
var d{N} >= 0;   # L1 distance (sum of lat + lng components)
var DTotalCost; 

minimize tcost: sum {i in N} c[i] * d[i] + DTotalCost; 

subject to

latA {i in N}: dlat[i] >= 2 * pi * R * (dc_lat-lat[i])/360;
latB {i in N}: dlat[i] >= 2 * pi * R * (lat[i]-dc_lat)/360;
lngA {i in N}: dlng[i] >= 2 * pi * R * (dc_lng-lng[i])/360;
lngB {i in N}: dlng[i] >= 2 * pi * R * (lng[i]-dc_lng)/360;
dist {i in N}: d[i] = dlat[i] + dlng[i];
buildcost: DTotalCost = DC * DCost;
