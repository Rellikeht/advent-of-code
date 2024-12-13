import System.Environment
import qualified Data.Map as Map
import Control.Monad.ST
import Data.STRef

main = do
    args <- getArgs
    steps <- if null args then return 25 else return $ read $ head args
    interact $ show . solve steps . map read . words

solve :: Int -> [Int] -> Int
solve _ [] = 0

-- from https://stackoverflow.com/questions/2233409/haskell-mutable-map-tree
memoize :: Ord k => (k -> ST s a) -> ST s (k -> ST s a)
memoize f = do
    mc <- newSTRef Map.empty
    return $ \k -> do
        c <- readSTRef mc
        case Map.lookup k c of
            Just a -> return a
            Nothing -> do
                a <- f k
                writeSTRef mc (Map.insert k a c) >> return a
