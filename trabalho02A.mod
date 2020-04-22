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
param MaxDC := 5;

# Distance calculus
param a{i in N, j in N} := max(2 * pi * R * (lat[j]-lat[i])/360 , 2 * pi * R * (lat[i]-lat[j])/360); 
param b{i in N, j in N} := max( 2 * pi * R * (lng[j]-lng[i])/360, 2 * pi * R * (lng[i]-lng[j])/360);
param d{i in N, j in N} := a[i,j] + b[i,j];

#Main variables: 
var dc_open{N} binary;
var dc_serving_dc{N , N} binary;
var DTotalCost; 


minimize tcost: sum {i in N, j in N} c[i] * d[i,j] * dc_serving_dc[i,j]  + DTotalCost; 

subject to
serving {j in N}: sum{i in N} dc_serving_dc[i, j] = 1;  
max_dc: sum {i in N} dc_open[i] <= MaxDC;
buildcost: DTotalCost = DC * DCost;
