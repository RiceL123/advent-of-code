module Main (main) where

import System.IO
import Data.List
import Text.Read (readMaybe)

main :: IO ()
-- main = part1 "day01.txt"
main = part2 "day01.txt"

part1 :: FilePath -> IO ()
part1 file_path = do
    file_lines <- toLinesList file_path
    let (list1, list2) = linesToUnzippedInts file_lines
    let total_distance = sum $ map (\(left_n, right_n) -> abs (left_n - right_n)) (zip (sort list1) (sort list2))
    print total_distance

toLinesList :: FilePath -> IO [String]
toLinesList inputFile = do
  content <- readFile inputFile
  let linesList = lines content
  return linesList

linesToUnzippedInts :: [String] -> ([Integer], [Integer])
linesToUnzippedInts lines = unzip $
    map (\line ->
        let [left_str, right_str] = words line
        in (read left_str :: Integer, read right_str :: Integer)
    ) lines

part2 :: FilePath -> IO ()
part2 file_path = do
    file_lines <- toLinesList file_path
    let (list1, list2) = linesToUnzippedInts file_lines
    let total_similarity = sum $ map (\x -> similarity x list2) list1
    print total_similarity

similarity :: Integer -> [Integer] -> Integer
similarity x list2 = x * (fromIntegral $ length $ filter (\y -> y == x) list2)
