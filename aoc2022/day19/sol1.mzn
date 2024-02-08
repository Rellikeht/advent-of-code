% Solution in minizinc, because I'm too stupid to do it in
% typical language and definitely to do it in ocaml

int: N;
int: maxType = 4;
%int: maxTime = 24;
int: maxTime = 2;

set of int: Time = 0..maxTime;
set of int: Wtime = 1..maxTime;
set of int: Blueprints = 1..N;
set of int: Types = 1..maxType;

% ore for ore robot
% ore for clay robot
% ore and clay for obsidian robot
% ore and obsidian for geode robot
array[Blueprints, 1..6] of int: blueprints;

int: maxResource = N*(N-1);
set of int: Resources = 0..maxResource;
set of int: Robots = 0..maxTime+1;

% ore, clay, obisidian, geode
array[Time, Blueprints, Types] of var Resources: resources;
array[Time, Blueprints, Types] of var Robots: robots;
var Resources: maxQuality;
var 0..N: bestBlueprint;

constraint forall(i in Blueprints)(robots[0, i, 1] == 1);
constraint forall(i in Blueprints, j in 2..maxType)(robots[0, i, j] == 0);
constraint forall(i in Wtime, j in Blueprints, k in Types)(
    (robots[i, j, k] == robots[i-1, j, k]+1) \/
    (robots[i, j, k] == robots[i-1, j, k])
);

constraint forall(i in Blueprints, j in Types)(resources[0, i, j] == 0);
constraint forall(i in Wtime, j in Blueprints, k in Types)(
    resources[i, j, k] == resources[i-1, j, k] + robots[i-1, j, k]
);

constraint maxQuality == max(i in Blueprints)(resources[maxTime, i, maxType]);
constraint bestBlueprint = max([
    if resources[maxTime, i, maxType] == maxQuality
    then i else 0
    endif | i in Blueprints
]);

solve maximize maxQuality;
output ["\(bestBlueprint)\n"];
output ["\([
  "\([resources[t, b, i] | i in Types]) " ++
  "\([robots[t, b, i] | i in Types])\n"
| b in Blueprints])\n" | t in Time
];

%output [
%  "\([resources[maxTime, b, i] | i in Types]) " ++
%  "\([robots[maxTime, b, i] | i in Types])\n"
%| b in Blueprints];


%array[Blueprints] of var int: quality;
%constraint forall(i in Blueprints)(quality[i] == resources[maxTime, i, 4]);
%constraint maxQuality == max(quality);
%constraint bestBlueprint = max([if quality[i] == maxQuality then i else -1 endif | i in 1..N]);
