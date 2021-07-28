{-# LANGUAGE FlexibleInstances, UndecidableInstances, DuplicateRecordFields #-}

module Main where

import Control.DeepSeq
import Control.Monad
import Data.Array
import Data.Foldable as F
import Data.Int
import Data.List
import qualified Data.Map.Strict as M
import qualified Data.Set as S
import Debug.Trace
import System.Environment
import System.IO

radixSort (from, to_inclusive) keyf xs=
  F.foldl' extend [] reversed_range
  where
    buckets = accumArray (flip (:)) []
      (from, to_inclusive) [((keyf x), x) | x <- xs]
    reversed_range = reverse $ range (from, to_inclusive)
    extend r x = F.foldl' (flip (:)) r (buckets ! x)

-- bnds: alphabet bounds
suffixArrayDc3 :: Ix a => (a, a) -> [a] -> [Int]
suffixArrayDc3 bnds xs = case xs of
  [] -> []
  _ -> sa
  where
    n = length xs
    xsArray = listArray (0, n - 1) xs
    sorted = radixSort bnds (xsArray!) (indices xsArray)
    nextRank (lastKey, lastIndex) thisKey
      = (thisKey, if thisKey == lastKey then lastIndex else lastIndex + 1)
    minElem = xsArray ! (head sorted)
    r :: [Int]
    r = (
      map snd
      . drop 1
      . scanl' nextRank (minElem, 1)
      . map (xsArray!)) sorted
    rmap = array (0, n - 1) $ zipWith (,) sorted r
    sa = drop 2 $ suffixArrayDc3Internal (n + 2) ((elems rmap) ++ [0, 0])

suffixArrayDc3Internal :: Int -> [Int] -> [Int]
suffixArrayDc3Internal n xs
  | n < 10 = bf
  | otherwise = sa
  where
    -- brute force
    suffixes = take n $ scanr (:) [] xs
    bf' = sortBy (\x y -> compare (fst x) (fst y)) $ zipWith (,) suffixes [0..]
    bf = map snd bf'

    revB = accumArray (flip (:)) [] (0, 2) [(x `mod` 3, x) | x <- [0..n - 1]]
    b0 = reverse (revB ! 0)
    b1 = reverse (revB ! 1)
    b2 = reverse (revB ! 2)
    len1 = length b1
    len2 = length b2
    b12 = b1 ++ b2

    getRank arr idx = r
      where
        r = if idx >= n
        then n - 1 - idx
        else arr ! idx

    xsArray = listArray (0, n - 1) xs
    xsRk = getRank ((xsArray ! (n - 1)) `seq` xsArray)

    rerankTriples idxs =
      array (0, n - 1) $ zipWith (,) c3 r3
      where
        c1 = radixSort (-2,n - 1) (xsRk. (+2)) idxs
        c2 = radixSort (-1,n - 1) (xsRk. (+1)) c1
        c3 = radixSort (0,n - 1) xsRk c2
        nextRank (lastKey, lastIndex) thisKey
          = (thisKey, if thisKey == lastKey then lastIndex else lastIndex + 1)
        keyFnList = zipWith (.) (replicate 3 xsRk) [id, (+1), (+2)]
        keyFn = (zipWith ($) keyFnList) . (replicate 3)
        r3 = (
          map snd
          . drop 1
          . scanl' nextRank ([-3, -3, -3], -1)
          . map keyFn) c3

    -- Note that the locations of 3k are not defined.
    rank12 = rerankTriples b12
    sa12' = suffixArrayDc3Internal (len1 + len2) $ map (rank12!) b12
    rank12' = array (0, len1 + len2 - 1) $ zipWith (,) sa12' [0..]

    getRank3 i = case i `mod` 3 of
      0 -> xsRk i
      1 -> getRank rank12' $ i `quot` 3
      2 -> getRank rank12' $ (i `quot` 3) + len1
    rank' = listArray (0, n - 1) $ map getRank3 [0..n - 1]
    sa12 = map
        (\x -> if x >= len1 then (3 * (x - len1) + 2) else (3 * x + 1)) sa12'

    xsRk' = getRank rank'
    sa0 = radixSort (0, n - 1) xsRk'
        $ radixSort (-3, n) (xsRk' . (+1)) b0

    -- mergeSort sa0 sa12
    ms' [] pos12 = pos12
    ms' pos0 [] = pos0
    ms' p0@(x0:pos0) p12@(x12:pos12) =
      if cmp3 x0 x12 == LT
        then x0:(ms' pos0 p12)
        else x12:(ms' p0 pos12)
      where
        getRk3 otherX x =
          if (otherX `mod` 3 == 0) || (x `mod` 3 == 0)
            then (xsRk x) else (xsRk' x)
        cmp3 x y = case r of
          EQ -> cmp3 (x + 1) (y + 1)
          _ -> r
          where
            r = compare (getRk3 y x) (getRk3 x y)
    sa = ms' sa0 sa12

-- Returns in the order of the Suffix Array
getHeight sa xs =
  array (0, n - 1) $ zipWith (,) (elems saArrayT) h
  where
    dec' x = if x == 0 then 0 else x - 1
    n = length xs
    saArray = listArray (0, n - 1) sa
    saArrayT = array (0, n - 1)
      $ zipWith (,) (elems saArray) (indices saArray)
    xsArray = listArray (0, n - 1) xs
    getHeight lastHeight curIdx
      | sIdx == 0 = 0
      | otherwise = getMaxHeight (dec' lastHeight)
      where
        sIdx = saArrayT ! curIdx
        prevIdx = saArray ! (sIdx - 1)
        getMaxHeight len
          | (prevIdx + len >= n)
            || (curIdx + len >= n)
            || (xsArray ! (prevIdx + len)) /= (xsArray ! (curIdx + len))
            = len
          | otherwise  = getMaxHeight (len + 1)
    h = drop 1 $ scanl' getHeight 0 [0..n - 1]

data AlphaTrackerPair = AlphaTrackerPair {
    fromLeft :: Array Int (M.Map Char Int),
    fromRight :: Array Int (M.Map Char Int)
  } deriving (Show)

makeAlphaTracker bnds initVal =
  M.fromList [(alpha, initVal) | alpha <- (range bnds)]

trackAlpha n bnds xs =
  (fromLeft trackerPair) `seq` (fromRight trackerPair) `seq` trackerPair
  where
    addChar m (pos, ch) =
      M.update (\_ -> Just pos) ch m
    indexedXs = zipWith (,) [0..n - 1] xs

    left = (
        listArray (0, n - 1)
        . drop 1
        . scanl' addChar (makeAlphaTracker bnds (-1))) indexedXs
    right = (
        listArray (0, n - 1)
        . take n
        . scanr (flip addChar) (makeAlphaTracker bnds n)) indexedXs
    trackerPair = AlphaTrackerPair {
        fromLeft = left `deepseq` left,
        fromRight = right `deepseq` right
      }

toMod :: Int32
toMod = 1000000007
mul x y = fromIntegral $ (x' * y') `mod` (fromIntegral toMod)
  where
    x' = (fromIntegral x) :: Int64
    y' = (fromIntegral y) :: Int64
add x y =
  if s >= toMod then s - toMod else s
  where s = x + y
sub x y = if s < 0 then s + toMod else s
  where s = x - y

makePowerTable :: Int -> Int -> Array Int (Array Int Int32)
makePowerTable n maxP
  = table
  where
    p1 = map fromIntegral (1:[1..n])
    plusOnePower :: Int -> [[Int32]] -> [[Int32]]
    plusOnePower 1 lastPs = lastPs
    plusOnePower k lastPs = plusOnePower (k - 1) (nextP:lastPs)
      where
        lastP = head lastPs
        nextP = zipWith mul lastP $ map fromIntegral [0..n]
    toPowerArray p = pa `deepseq` pa
      where pa = listArray (0, n) $ drop 1 $ scanl' add 0 p
    toPowerArrays [] acc = listArray (1, n) acc
    toPowerArrays (x:xs) acc = toPowerArrays xs ((toPowerArray x):acc)
    table = toPowerArrays (plusOnePower maxP [p1]) []

superFunctionalStrings s =
    F.foldl' add 0 $ zipWith plusSuffix sa (elems height)
    where
      n = length s
      sa = suffixArrayDc3 ('a', 'z') s
      saArray = sa `deepseq` listArray (0, n - 1) sa
      height =  getHeight sa s
      alphaTrackerPair = trackAlpha n ('a', 'z') s
      table = makePowerTable n 26
      plusSuffix start length
        | end >= n = 0
        | otherwise = totalDelta
        where
          end = start + length
          leftTracker = (fromLeft alphaTrackerPair) ! end
          rightTracker = (fromRight alphaTrackerPair) ! end
          included = S.fromList
            $ map fst
            $ filter (\(_, v) -> v >= start && v <= end) (M.assocs leftTracker)
          base :: Int
          base = S.size included
          nextLocs =
            sort
            $ map snd
            $ filter
              (\(k, v) -> v > end && v < n && not (S.member k included))
              (M.assocs rightTracker)
          plusLoc p lastLoc [] acc = acc
          plusLoc p lastLoc (nextLoc:remainLocs) acc =
            plusLoc (p + 1) nextLoc remainLocs (add acc delta)
            where
              powerArray = table ! p
              r = nextLoc - start
              l = lastLoc - start
              delta = sub (powerArray ! r) (powerArray ! l)
          totalDelta = plusLoc base end (nextLocs ++ [n]) 0


main :: IO()
main = do
    stdout <- getEnv "OUTPUT_PATH"
    fptr <- openFile stdout WriteMode
    -- let fptr = stdout

    t <- readLn :: IO Int

    forM_ [1..t] $ \tItr -> do
        s <- getLine

        let result = superFunctionalStrings s

        hPutStrLn fptr $ show result

    hFlush fptr
    hClose fptr
