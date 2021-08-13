{-# LANGUAGE RankNTypes #-}
import Data.List (sortBy, words)
import Control.Applicative
import Control.Monad
import Control.Monad.ST
import Data.Array
import Data.Array.ST

newtype UM a = UM {runUM' :: forall s. (STArray s Int (Maybe Int)) -> ST s a}

instance Functor UM where
  fmap f (UM a) = UM ((fmap . fmap) f a)

instance Applicative UM where
  (<*>) = ap
  pure = return

instance Monad UM where
  return a = UM (\g -> return a)
  (UM a) >>= f = UM (\g -> (fmap (runUM' . f) (a g)) >>= ($ g))

runUM :: Int -> UM a -> a
runUM n (UM u) = runST (newArray (1,n) Nothing >>= u)

umGet :: Int -> UM Int
umGet i = UM $ \g -> fmap (\x -> case x of {Nothing -> i; Just v -> v}) $ readArray g i
umPut :: Int -> Int -> UM ()
umPut i v = UM $ \g -> writeArray g i (Just v)

uFind :: Int -> UM Int
uFind i = do
  j <- umGet i
  if i == j
    then return j
    else do
      k <- uFind j
      if k == j then return () else umPut i k
      return k

uMerge :: Int -> Int -> UM Bool
uMerge a b = do
  a' <- uFind a
  b' <- uFind b
  if a' == b'
    then return False
    else umPut a' b' >> return True

kruskal :: Int -> [(Int,Int,Integer)] -> Integer
kruskal n e = sum $
  runUM n $ forM (sortBy (\ ~(_,_,a) ~(_,_,b) -> a `compare` b) e) $
    \ ~(a,b,w) -> fmap (\v -> if v then w else 0) $ uMerge a b

main = do
  ~(n:m:_) <- fmap (map read . words) getLine
  e <- forM [1 .. m] $ const $
    fmap ((\ ~(a:b:w:_) -> (fromIntegral a, fromIntegral b,w)) . map read . words) getLine
  s <- fmap read getLine :: IO Int -- unused
  print $ kruskal n e
