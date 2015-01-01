{-# LANGUAGE LambdaCase #-}
module Main(main) where

import System.IO
import Data.Functor
import Text.Read (readMaybe)
import System.Environment (getArgs)

import Path

parse :: Int -> Int -> Int -> IO ()
parse x y z = do
    arr <- fmap words . lines <$> getContents
    mapM_ (putStrLn . convert) (findPath $ fmap read <$> arr)
    where
        convert (N count) = "y-" ++ show (count*y)
        convert (S count) = "y"  ++ show (count*y)
        convert (W count) = "x-" ++ show (count*x)
        convert (E count) = "x"  ++ show (count*x)
        convert Up        = "z"  ++ show z
        convert On        = "+"
        convert Off       = "-"

main :: IO ()
main = fmap readMaybe <$> getArgs >>= \case
    [Just xyz]                  -> parse xyz xyz xyz
    [Just xy , Just z]          -> parse xy  xy  z
    [Just x  , Just y, Just z]  -> parse x   y   z
    _                           -> hPutStrLn stderr "usage: steps-x [[steps-y] steps-z]"
