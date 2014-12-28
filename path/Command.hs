module Main(main) where

import Data.Functor
import Control.Monad (forM_)

import Path

main :: IO ()
main = do
    arr <- fmap (fmap read . words) . lines <$> getContents
    forM_ (findPath arr) $ print

