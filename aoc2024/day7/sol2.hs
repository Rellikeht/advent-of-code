-- {-# LANGUAGE MagicHash #-}
-- import GHC.Exts
-- import GHC.Integer.Logarithms
import Data.Char ( isNumber )
import GHC.Float ( float2Int )

main = interact $ (++ "\n") . show . sum . map (check . parse) . lines

parse :: String -> ( Int, [ Int ] )
parse line = ( target, numbers )
  where
    target = read $ takeWhile isNumber line

    rest = drop 2 $ dropWhile (/= ':') line

    numbers = map read $ words rest

check :: ( Int, [ Int ] ) -> Int
check ( target, n : ns )
    | find target n ns = target
    | otherwise = 0
  where
    find target n [] = target == n
    find target n (x : xs) = (n <= target) && (add || mul || conc)
      where
        add = find target (n + x) xs

        mul = find target (n * x) xs

        conc = find target (concat n x) xs

        concat :: Int -> Int -> Int
        concat n x = zeros * n + x
          where
            zeros = 10 ^ (digits + 1)

            -- slower :(
            -- digits = I# (integerLogBase# 10 (toInteger x))
            digits = float2Int $ logBase 10 $ fromIntegral x
