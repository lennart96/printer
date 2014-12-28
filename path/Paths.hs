{-# LANGUAGE DeriveFunctor #-}

module Paths (points) where

-- permature optimization is the root of all evil
import Control.Applicative
import Data.Foldable
import Data.Monoid
import qualified Data.List as List
import Prelude hiding (foldr, maximum)

type Position = (Int, Int)
data Dot a = Dot Position a deriving Functor

data Matrix a = Matrix { unMatrix :: [[Dot a]] }

instance Functor Matrix where
    f `fmap` x = Matrix $ fmap (fmap (fmap f)) (unMatrix x)

unDot :: Dot a -> a
unDot (Dot _ x) = x

instance Foldable Matrix where
    f `foldMap` lists = foldMap id $ foldMap unDot <$> unMatrix (fmap f lists)

points :: [[Int]] -> [[[[(Int,Int)]]]]
points = paths . fromList

newMatrix :: Int-> Int-> a -> Matrix a
newMatrix w h default' = Matrix $ do
    x <- [0..w-1]
    [ do
    y <- [0..h-1]
    return $ Dot (x,y) default'
    ]

fromList :: [[a]] -> Matrix a
fromList list = let
    (w,h) = size list
    in Matrix $ do
    x <- [0..w-1]
    [ do
    y <- [0..h-1]
    return $ Dot (x,y) (list !! x !! y)
    ]

size :: [[a]] -> (Int, Int)
size [] = (0,0)
size m = (length m, length (head m))

transpose :: Matrix a -> Matrix a
transpose = Matrix . List.transpose . unMatrix

data Dir = H | V

dir :: Int -> Dir
dir = let dirs = H:V:dirs in (dirs!!)

paths :: Matrix Int -> [[[[(Int,Int)]]]]
paths m = do
    z <- [0..maximum m - 1]
    return $ layer $ fmap (>z) $ case dir z of
        H -> m
        V -> transpose m

layer :: Matrix Bool -> [[[(Int,Int)]]]
layer = fmap lane . unMatrix

lane :: [Dot Bool] -> [[(Int,Int)]]
lane = lane' []
    where
    lane' :: [(Int,Int)] -> [Dot Bool] -> [[(Int,Int)]]
    lane' [] [] = []
    lane' xs [] = [reverse xs]
    lane' [] (Dot _ False:ds) = lane' [] ds
    lane' xs (Dot _ False:ds) = reverse xs:lane' [] ds
    lane' xs (Dot pos True:ds) = lane' (pos:xs) ds

main :: IO ()
main = do
    input <- getContents
    let arr = (fmap (fmap read . words) . lines) input :: [[Int]]
    putStrLn $ unlines $ fmap show $ paths $ fromList arr
