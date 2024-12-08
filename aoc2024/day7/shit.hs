import Data.Char ( isNumber )
import GHC.Float ( float2Int )

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
    find target n (x : xs) = (n <= target) && (add || mul || conc)
      where
        add = find target (seq 0 (n + x)) xs
        mul = find target (seq 0 (n * x)) xs
        conc = find target (concat n x) xs
        concat :: Int -> Int -> Int
        -- implementation with strings, slow as fuck
        concat n x = read $ show n ++ show x
