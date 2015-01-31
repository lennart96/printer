module Main(main) where

import System.Hardware.Serialport
import Control.Monad
import System.Environment (getArgs)
import System.IO
import System.IO.Error

hGetLineNoFail :: Handle -> IO String
hGetLineNoFail h = hGetLine h `catchIOError` (\e -> print e >> hGetLineNoFail h)

communicate :: Handle -> String -> IO ()
communicate h "-i" = interactive h
communicate h msg = do
    hPutStr h msg
    putStrLn $ "> " ++ msg
    response <- hGetLineNoFail h
    putStrLn $ "< " ++ response


interactive :: Handle -> IO ()
interactive h = do
    input <- getContents
    forM_ (lines input) $ \msg -> do
        putStrLn $ "> " ++  msg
        hPutStrLn h msg
        response <- hGetLineNoFail h
        putStrLn $ "< " ++ response

main :: IO ()
main = do
    (device:cmds) <- getArgs
    port <- hOpenSerial device $ defaultSerialSettings { timeout = 60000 }
    forM_ cmds $ communicate port
    hClose port
