import Data.List
import Data.Function
import Control.Monad
import Data.Bits
import qualified Data.Vector.Unboxed.Mutable as M
import qualified Data.Vector.Unboxed as V
import Data.Maybe
import Data.IORef
import qualified Data.ByteString.Char8 as B

type Dollar = Int
type Vertex = Int
type Mask = Int -- vertex mask

main :: IO ()
main = do
  rd <- intReader
  [n, m] <- rd 2
  ds <- fmap V.fromList $ rd n -- dollars
  es <- M.replicate n (0 :: Mask) -- edges
  let addEdge u v = M.modify es (flip setBit v) u
  input <- replicateM m $ fmap (map pred) $ rd 2
  forM_ input $ \[u, v] -> addEdge u v >> addEdge v u
  es1 <- V.freeze es
  putStrLn $ solve ds es1

solve :: V.Vector Dollar -> V.Vector Mask -> String
solve ds es = let (d, c) = go (sortBy (flip compare `on` degree) [0..pred n]) (2 ^ n - 1) 0 0 (0, 0) in show d ++ " " ++ show c
  where
  n = V.length ds
  go :: [Vertex] -> Mask -> Int -> Dollar -> (Dollar, Int) -> (Dollar, Int)
  go pendvs pendm zeroc accd bestp
    | null pendvs = updateBest bestp accd (2 ^ zeroc)
    | not $ testBit pendm curv = go nextvs pendm zeroc accd bestp
    | isolated = if curd == 0
      then go nextvs pendm1 (succ zeroc) accd bestp
      else go nextvs pendm1 zeroc (accd + curd) bestp
    | otherwise = let bestp' = go nextvs pendm2 zeroc (accd + curd) bestp in go nextvs pendm1 zeroc accd bestp'
    where
    pendm1 = clearBit pendm curv
    pendm2 = pendm1 .&. (complement cure)
    (curv : nextvs) = pendvs
    curd = dollar curv
    cure = pendm .&. edgeMask curv
    isolated = cure == 0
  degree = popCount . edgeMask
  edgeMask = (es V.!)
  dollar = (ds V.!)
  updateBest (d, c) d1 c1
    | d1 > d = (d1, c1)
    | d > d1 = (d, c)
    | otherwise = (d, c + c1)

intReader :: IO (Int -> IO [Int])
intReader = do
  ws <- fmap ((concatMap B.words) . B.lines) B.getContents >>= newIORef
  return $ \n -> do
    xs <- readIORef ws
    writeIORef ws (drop n xs)
    return (take n . map (fst . fromJust . B.readInt) $ xs)