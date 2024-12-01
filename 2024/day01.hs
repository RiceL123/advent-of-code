module Main (main) where

import System.IO
import Data.List
import Text.Read (readMaybe)

main :: IO ()
-- main = part1 "day01.txt"
main = part2 "day01.txt"

pathToUnzippedInts :: FilePath -> IO ([Integer], [Integer])
pathToUnzippedInts inputFile = do
    content <- readFile inputFile
    let linesList = lines content
    let unzippedInts = unzip $
            map (\line ->
                let [left_str, right_str] = words line
                in (read left_str :: Integer, read right_str :: Integer)
            ) linesList
    return unzippedInts

part1 :: FilePath -> IO ()
part1 filePath = do
    (list1, list2) <- pathToUnzippedInts filePath
    let total_distance = sum $ map (\(left_n, right_n) -> abs (left_n - right_n)) (zip (sort list1) (sort list2))
    print total_distance

part2 :: FilePath -> IO ()
part2 filePath = do
    (list1, list2) <- pathToUnzippedInts filePath
    let total_similarity = sum $ map (\x -> x * fromIntegral (length $ filter (== x) list2)) list1
    print total_similarity
