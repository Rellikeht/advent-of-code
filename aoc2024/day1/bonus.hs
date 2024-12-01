import Data.List ( sort )
import Data.Map

main = interact $ tasks . plists ( [], [] ) . words

plists :: ( [ Int ], [ Int ] ) -> [ String ] -> ( [ Int ], [ Int ] )
plists ( xs, ys ) (x : y : rest) = plists ( read x : xs, read y : ys ) rest
plists content [] = content

tasks :: ( [ Int ], [ Int ] ) -> String
tasks ( l1, l2 ) = "Part 1: " ++ p1 ++ "\nPart 2: " ++ p2 ++ "\n"
  where
    p1 = show $ part1 l1 l2

    p2 = show $ part2 l1 l2

part1 :: [ Int ] -> [ Int ] -> Int
part1 l1 l2 = diffs 0 (sort l1) (sort l2)
  where
    diffs n [] [] = n
    diffs n (x : xs) (y : ys) = diffs (n + abs (x - y)) xs ys

part2 :: [ Int ] -> [ Int ] -> Int
part2 l1 l2 = counts 0 l1 (freqs empty l2)
  where
    counts n [] _ = n
    counts n (x : xs) m = case Data.Map.lookup x m of
        Nothing -> counts n xs m
        Just y -> counts (n + x * y) xs m

    freqs m [] = m
    freqs m (x : xs) = freqs newM xs
      where
        newM = insert x newF m

        newF = findWithDefault 0 x m + 1
