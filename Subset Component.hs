{-# LANGUAGE ViewPatterns #-}

module Main where

import Control.Monad
import Data.Array
import Data.Int
import Data.Bits
import Data.List
--import System.Random

addClique c components
  | adjUnion == 0 = notAdj
  | otherwise = adjUnion : notAdj 
  where
    (adj,notAdj) = partition (\co -> c .&. co /= 0) components
    adjUnion = c .|. foldl (.|.) 0 adj

search :: [Int64] -> [Int64] -> Int64 -> Int
search [] components covered = length components + 64 - popCount covered
search (c:cs) components covered = search cs components covered + search cs (addClique c components) (covered .|. c) where


getList :: Int -> IO [String]
getList _ = words `liftM` getLine

readTest :: IO [Int64]
readTest = do
  n <- read `liftM` getLine
  map read `liftM` getList n

--randomTest :: Int -> IO [Int64]
--randomTest n = do
--  gen <- newStdGen
--  return $ randomTest' n gen
--  where
--    randomTest' 0 _ = []
--    randomTest' n gen = x : randomTest' (n-1) gen'
--      where (x,gen') = random gen

main::IO()
main = do
  --test <- randomTest 20
  test <- readTest
  print $ search test [] 0
