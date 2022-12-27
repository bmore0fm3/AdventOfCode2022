#!/usr/bin/env rexx
/*REXX

    adventOfCodeDay25
    https://adventofcode.com/2022/day/25

    SNAFU number counting is base 5. The minus symbol is valued at -1, and the 
    equal symbol is valued at -2. 

    1. Convert the Special Numeral-Analogue Fuel Units (SNAFU)
       puzzleInput.txt file to decimal
    2. Get the sum of the decimal values
    3. Bob can't read decimal. Convert it back to SNAFU

*/

/*trace i*/
rc = 0
maxRC = 0

inputFileName = 'puzzleInput.txt'

parse source system invocation fullProgramPath
fullProgramPath = reverse(fullProgramPath)
parse var fullProgramPath 'XER.' programName '/' .
programName = reverse(programName)

/*check if the file exists*/
queryFile = .stream~new(inputFileName)
if queryFile~query("exists") = " " then do
    rc = 8
    maxRC = max(rc, maxRC)
    say time() programName inputFileName "does not exist"
    exit maxRC
    end
else 
    queryFile~close

/*read in the file*/
inputFile = .stream~new(inputFileName)
lines = inputfile~arrayin
inputFile~close


call SNAFU2Decimal lines


exit rc

/*
    Name: SNAFU2Decimal
    Info: Input is a list of SNAFU numbers. Transalate SNAFU to Decimal.
          Return a text file with SNAFU numbers converted to decimal.
*/
SNAFU2Decimal: procedure

this_ = 'SNAFU2Decimal'
arg lines .

loop i over lines
    exponentNumber = length(i)
    exponentNumber = exponentNumber - 1
    answer = 5 ** exponentNumber
    say time() this_ "String is" exponentNumber "long. It has highest position",
                     "value of" answer
    end 

return rc






/*AddItUp:
    Input is a list of decimal numbers
    Get the sum of that list
    Return the sum
*/

/*Decimal2SNAFU:
    Input is a list of decimal numbers
    Translate the decimal numbers to SNAFU
    return the SNAFU number
*/