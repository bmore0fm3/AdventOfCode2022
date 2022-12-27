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
parse var fullProgramPath 'xer.' this_ '/' .
this_ = reverse(this_)


/*check if the file exists*/
queryFile = .stream~new(inputFileName)
if queryFile~query("exists") = " " then do
    rc = 8
    maxRC = max(rc, maxRC)
    say time() this_ inputFileName "does not exist"
    exit maxRC
end
else 
    queryFile~close

/*read in the file*/
say time() this_ "Reading" inputFileName "..."
say
inputFile = .stream~new(inputFileName)
lines = inputfile~arrayin
if rc == 0 then 
    say time() this_ 
inputFile~close

say time() this_ "Converting SNAFU numbers to decimal..."
say

call SNAFU2Decimal lines


exit rc

/*
    Name: SNAFU2Decimal
    Note: Input is a list of SNAFU numbers. The goal is to transalate SNAFU 
          numbers to decimal numbers. Process is as follows:
            1. Get the length of the SNAFU number
            2. Parse the SNAFU number to get the first number
            3. Calculate the position # by subtracting 1 from SNAFU number 
               length. Then use that number as an exponent for 5. 
               Ex. 5^(length-1)
            4. Multiply position value by nextChar value
            5. Save the value to stem variable
            6. Sum up the stem and store
          Return a text file with SNAFU numbers converted to decimal.
*/
SNAFU2Decimal: procedure
this_ = 'SNAFU2Decimal'

arg txtLines .

loop i over txtLines
    snafuConversion = 0
    snafuDecimalValue.0 = 0
    inputStrLength = length(i)
    say time() this_ "SNAFU string" i "has" inputStrLength "digits."

    /*Calculate the positonal value. Example positon is 5^2=25 */
    counter = 0
    do while inputStrLength > 0 
        parse var i nextChar+1 i  
        /*say nextChar*/
        positionValue = 5 ** (inputStrLength - 1)
        counter = counter + 1
        snafuDecimalValue.0 = counter

        /*Convert the - and = to -1 and -2 respectively*/
        if nextChar == '-' then
            snafuDecimalValue.counter = positionValue * -1 
        else if nextChar == '=' then
            snafuDecimalValue.counter = positionValue * -2
        else
            snafuDecimalValue.counter = positionValue * nextChar

        /*say time() this_ "snafuDecimalValue = " snafuDecimalValue.counter*/
        inputStrLength = inputStrLength - 1 
    end 

    /*Get sum of each position to complete conversion to decimal*/
    do j = 1 to snafuDecimalValue.0 
        snafuConversion = snafuDecimalValue.j + snafuConversion
    end

    snafuConversion = strip(snafuConversion)
    queue snafuConversion

    say time() this_ "SNAFU number" i "has a decimal value of" snafuConversion
    say

end 

say
say time() this_ "total items in queue:" queued()

/*create output textfile*/
outFile = .stream~new("snafu2Decimal.txt")

/*write queued data to text file*/
do k = 1 for queued()
    parse pull outputStr
    outputStr = strip(outputStr)
    outFile~lineout(outputStr)
end k

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