import Data.Char ( isNumber )

main = interact $ (++ "\n") . show . sum . map (check . parse) . lines

parse :: String -> (Int, [Int])
parse line = (target, numbers)
  where
    target = read $ takeWhile isNumber line
    rest = drop 2 $ dropWhile (/= ':') line
    numbers = map read $ words rest

check :: (Int, [Int]) -> Int
check (target, n : ns)
    | find target n ns = target
    | otherwise = 0
  where
    find target n [] = target == n
    find target n (x : xs) = find target np xs || find target nm xs
      where
        np = n + x
        nm = n * x
