% Solution in minizinc, because I'm too stupid to do it in
% typical language and definitely to do it in ocaml

int N;
array[N, 6] of int: blueprints;

% TODO for optimization
%array[N] of int: maxPossibleQualities;
%int maxPossibleQuality = max(maxPossibleQualities);

array[N] of var int: quality;
var int: maxQuality;

% TODO all calculations

solve maximize maxQuality;
output max([if quality[i] == maxQuality then i else -1 endif | i in 1..N]);
