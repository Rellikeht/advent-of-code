% Solution in minizinc, because I'm too stupid to do it in
% typical language and definitely to do it in ocaml

int: N;
int: maxType = 4;
int: maxTime = 45;

set of int: Time = 0..maxTime;
set of int: Wtime = 1..maxTime;
set of int: Blueprints = 1..N;
set of int: Types = 1..maxType;

% ore for ore robot
% ore for clay robot
% ore and clay for obsidian robot
% ore and obsidian for geode robot
array[Blueprints, 1..6] of int: blueprints;

int: maxResource = maxTime*(maxTime-1) div 2;
set of int: Resources = 0..maxResource;
set of int: Robots = 0..maxTime;

% ore, clay, obisidian, geode
array[Time, Blueprints, Types] of var Resources: resources;
array[Time, Blueprints, Types] of var Robots: robots;
array[Blueprints] of var Resources: quality;
constraint forall(i in Blueprints)(quality[i] == resources[maxTime, i, 4]);

constraint forall(i in Blueprints, j in Types)(resources[0, i, j] == 0);
constraint forall(i in Blueprints)(robots[0, i, 1] == 1);
constraint forall(i in Blueprints, j in 2..maxType)(robots[0, i, j] == 0);
constraint forall(i in Wtime, j in Blueprints)(
    sum(k in Types)(robots[i, j, k]) == sum(k in Types)(robots[i-1, j, k])+1 \/
    sum(k in Types)(robots[i, j, k]) == sum(k in Types)(robots[i-1, j, k])
);
constraint forall(i in Wtime, j in Blueprints, k in Types)(
    (robots[i, j, k] == robots[i-1, j, k]+1) \/
    (robots[i, j, k] == robots[i-1, j, k])
);

% ore is used in all robots
% clay in obsidian
% obsidian in geode

% Ore robot
constraint forall(i in Wtime, j in Blueprints)(
    if resources[i-1, j, 1] < blueprints[j, 1]
    then robots[i, j, 1] == robots[i-1, j, 1] endif
);

% Clay robot
constraint forall(i in Wtime, j in Blueprints)(
    if resources[i-1, j, 1] < blueprints[j, 2]
    then robots[i, j, 2] == robots[i-1, j, 2] endif
);

% Obsidian robot
constraint forall(i in Wtime, j in Blueprints)(
    if resources[i-1, j, 1] < blueprints[j, 3] \/
    resources[i-1, j, 2] < blueprints[j, 4]
    then robots[i, j, 3] == robots[i-1, j, 3] endif
);

% Geode robot
constraint forall(i in Wtime, j in Blueprints)(
    if resources[i-1, j, 1] < blueprints[j, 5] \/
    resources[i-1, j, 3] < blueprints[j, 6]
    then robots[i, j, 4] == robots[i-1, j, 4] endif
);

% This isn't that easy, should go by resource not by robot

% Ore
constraint forall(i in Wtime, j in Blueprints)(
    resources[i, j, 1] == resources[i-1, j, 1] + robots[i-1, j, 1] -
    if robots[i, j, 1] == robots[i-1, j, 1]+1 then blueprints[j, 1]
    elseif robots[i, j, 2] == robots[i-1, j, 2]+1 then blueprints[j, 2]
    elseif robots[i, j, 3] == robots[i-1, j, 3]+1 then blueprints[j, 3]
    elseif robots[i, j, 4] == robots[i-1, j, 4]+1 then blueprints[j, 5]
    else 0 endif
);

% Clay
constraint forall(i in Wtime, j in Blueprints)(
    resources[i, j, 2] == resources[i-1, j, 2] + robots[i-1, j, 2] -
    if robots[i, j, 3] == robots[i-1, j, 3]+1
    then blueprints[j, 4] else 0 endif
);

% Obsidian
constraint forall(i in Wtime, j in Blueprints)(
    resources[i, j, 3] == resources[i-1, j, 3] + robots[i-1, j, 3] -
    if robots[i, j, 4] == robots[i-1, j, 4]+1
    then blueprints[j, 6] else 0 endif
);

% Geode
constraint forall(i in Wtime, j in Blueprints)(
    resources[i, j, 4] == resources[i-1, j, 4] + robots[i-1, j, 4]
);

% And the optimizations

%% robots

constraint forall(i in Wtime, j in Blueprints)(
    sum([robots[i, j, k] | k in Types]) <= i+1
);
constraint forall(i in Wtime, j in Blueprints, k in Types)(
    robots[i, j, k] >= robots[i-1, j, k]
);

constraint forall(i in Time, j in Blueprints)(
    robots[i, j, 1] <= max(1, i + 1 - blueprints[j, 1])
);

constraint forall(i in Time, j in Blueprints)(
    robots[i, j, 2] <= max(0, i + 1
      - blueprints[j, 2]
      )
);

constraint forall(i in Time, j in Blueprints)(
    robots[i, j, 3] <= max(0, i + 1 - blueprints[j, 2]
      - min(blueprints[j, 3], blueprints[j, 4])
      )
    );

constraint forall(i in Time, j in Blueprints)(
    robots[i, j, 4] <= max(0, i + 1 - blueprints[j, 2]
      - min(blueprints[j, 3], blueprints[j, 4])
      - min(blueprints[j, 5], blueprints[j, 6])
      )
);

%% resources

constraint forall(i in Time, j in Blueprints)(
    sum([resources[i, j, k] | k in Types]) <= max(i,
      i*(i-3) div 2
    )
);

constraint forall(i in Time, j in Blueprints)(
    resources[i, j, 2] <= max(0,
      i*(i-3) div 2 - blueprints[j, 2]
    )
);

constraint forall(i in Time, j in Blueprints)(
    resources[i, j, 3] <= max(0,
      i*(i-3) div 2 - blueprints[j, 2]
      - min(blueprints[j, 3], blueprints[j, 4])
    )
);

constraint forall(i in Time, j in Blueprints)(
    resources[i, j, 4] <= max(0,
      i*(i-3) div 2 - blueprints[j, 2]
      - min(blueprints[j, 3], blueprints[j, 4])
      - min(blueprints[j, 5], blueprints[j, 6])
    )
);

% Output

solve maximize sum(quality);

% output ["\([(i, quality[i], i*quality[i]) | i in Blueprints])\n"];
output ["\(product([quality[i] | i in Blueprints]))\n"];

% output ["\([
%   show(i in Types)(resources[t, b, i]) ++ " " ++
%   show(i in Types)(robots[t, b, i])
% | b in Blueprints])\n" | t in Time
% ];

%output ["\([
%  "\([resources[t, b, i] | i in Types]) " ++
%  "\([robots[t, b, i] | i in Types])\n"
%| b in Blueprints])\n" | t in Time
%];

%output [
%  "\([resources[maxTime, b, i] | i in Types]) " ++
%  "\([robots[maxTime, b, i] | i in Types])\n"
%| b in Blueprints];
