{-# LANGUAGE DeriveFunctor #-}
-- permature optimization is the root of all evil
import Control.Applicative
import Data.Foldable
import Data.Monoid
import qualified Data.List as List
import Prelude hiding (foldr, maximum)

type Position = (Int, Int)
data Dot a = Dot Position a deriving (Eq, Show, Functor)

data Matrix a = Matrix { unMatrix :: [[Dot a]] } deriving (Show, Eq)

instance Functor Matrix where
    f `fmap` x = Matrix $ fmap (fmap (fmap f)) (unMatrix x)

unDot :: Dot a -> a
unDot (Dot _ x) = x

instance Foldable Matrix where
    f `foldMap` lists = foldMap id $ foldMap unDot <$> unMatrix (fmap f lists)

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

flipH, flipV, transpose, rotL, rotR :: Matrix a -> Matrix a
flipH = Matrix . reverse . unMatrix
flipV = Matrix . fmap reverse . unMatrix
transpose = Matrix . List.transpose . unMatrix
rotL = flipH . transpose
rotR = flipV . transpose

size :: [[a]] -> (Int, Int)
size [] = (0,0)
size m = (length m, length (head m))

data Dir = H | V deriving (Show, Eq)
data Wind = N | S | E| W deriving (Show, Eq)

dir :: Int -> Dir
dir = let dirs = H:V:dirs in (dirs!!)

paths :: Matrix Int -> [[[(Int,Int)]]]
paths m = do
    z <- [0..maximum m - 1]
    return $ layer $ fmap (>z) $ case dir z of
        H -> m
        V -> rotR m

layer :: Matrix Bool -> [[(Int,Int)]]
layer = fmap lane . unMatrix

lane :: [Dot Bool] -> [(Int,Int)]
lane [] = []
lane (Dot pos True:ds) = pos:lane ds
lane (Dot _ False:ds) = lane ds

main :: IO ()
main = undefined
