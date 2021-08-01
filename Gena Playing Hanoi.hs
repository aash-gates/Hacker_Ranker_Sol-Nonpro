import Control.Monad
import Data.Maybe
import qualified Data.Vector.Unboxed as Vec
import qualified Data.Vector.Unboxed.Mutable as MVec
import Control.Monad.ST
import Data.List

index :: Vec.Vector Int -> Int
index c = sum (zipWith (*) (Vec.toList c) (iterate (*4) 1))

top :: Vec.Vector Int -> Int -> Maybe Int
top c i = i `Vec.elemIndex` c

representative :: Vec.Vector Int -> Vec.Vector Int
representative c
  | x >= y && y >= z = c
  | x >= z && z >= y = f [0, 1, 3, 2]
  | y >= x && x >= z = f [0, 2, 1, 3]
  | y >= z && z >= x = f [0, 2, 3, 1]
  | z >= x && x >= y = f [0, 3, 1, 2]
  | z >= y && y >= x = f [0, 3, 2, 1]
  where
    x = bottom 1
    y = bottom 2
    z = bottom 3
    bottom = fromMaybe 10 . top c'
    c' = Vec.reverse c
    f perm = Vec.map (fromJust . (`elemIndex` perm)) c

move :: Vec.Vector Int -> Int -> Int -> Maybe (Vec.Vector Int)
move c i j
  | is_valid_move = (Just d')
  | otherwise = Nothing
  where
    is_valid_move
      | isJust x && (isNothing y || fromJust x < fromJust y) = True
      | otherwise = False
    x = top c i
    y = top c j
    z = i `Vec.elem` (Vec.drop (fromJust x + 1) c)
    d = c Vec.// [(fromJust x, j)]
    d' = if (i == 0 || z) && (j == 0 || isJust y) then d else (representative d)

main :: IO ()
main = do
  n <- fmap read getLine
  c <- fmap (Vec.fromList . fmap (pred . read) . words) getLine
  print (run n (representative c))
    
run :: Int -> Vec.Vector Int -> Int
run n c = runST $ do
  s <- MVec.replicate (4^n) (-1 :: Int)
  MVec.write s 0 0
  let
    f [] [] _ = return ()
    f [] dss m = f (concat dss) [] (m + 1)
    f (c:cs) dss m = do
      let
        ds' = [fromJust d | i <- [0..3], j <- [0..3], i /= j, let d = move c i j, isJust d]
      ds_mb <- forM ds' $ \d -> do
        m' <- MVec.read s (index d)
        ans <- if m' /= -1 then return Nothing else do
          MVec.write s (index d) m
          return (Just d)
        return ans
      let
        ds = fmap fromJust . filter isJust $ ds_mb
      f cs (ds:dss) m
  f [Vec.replicate n 0] [] 1
  m <- MVec.read s (index c)
  return m