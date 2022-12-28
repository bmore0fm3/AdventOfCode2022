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

puzzleInputFile = 'puzzleInput.txt'
decimalInputFile = 'snafu2Decimal.txt'

/*get all the numbers and not just 9 by rexx default*/
numeric digits 22

/*Get this program's name*/
parse source system invocation fullProgramPath
fullProgramPath = reverse(fullProgramPath)
parse var fullProgramPath 'xer.' this_ '/' .
this_ = reverse(this_)

/*check if the file exists*/
queryFile = .stream~new(puzzleInputFile)
if queryFile~query("exists") = " " then do
    rc = 8
    maxRC = max(rc, maxRC)
    say time() this_ maxRC puzzleInputFile "does not exist"
    exit maxRC
end
else 
    queryFile~close


/*read in the puzzle file*/
say time() this_ "Reading" puzzleInputFile "..."
say

inputFile = .stream~new(puzzleInputFile)
lines = inputFile~arrayin

if rc > 0 then do
    say time() this_ rc "Error reading file"
    exit maxRC
end 
inputFile~close


say time() this_ "Converting SNAFU numbers to decimal..."
say

/*Convert the SNAFU numbers to decimal*/
call SNAFU2Decimal lines decimalInputFile
if rc > 4 then do
    maxRC = max(rc, maxRC)
    say time() this_ rc "Unable to generate SNAFU2DECIMAL list"
    exit maxRC
end


/*check if the decimal file exists*/
queryFile = .stream~new(decimalInputFile)
if queryFile~query("exists") = " " then do
    rc = 8
    maxRC = max(rc, maxRC)
    say time() this_ maxRC decimalInputFile "does not exist"
    exit maxRC
end
else 
    queryFile~close


/*read in the decimal file*/
drop inputFile lines
say time() this_ "Reading" decimalInputFile "..."
say

decimalFile = .stream~new(decimalInputFile)
decimalLines = decimalFile~arrayin

if rc > 0 then do
    maxRC = max(rc, maxRC)
    say time() this_ rc "Error reading file" decimalFile
    exit maxRC
end 
decimalFile~close


call AddItUp decimalLines
say result


exit maxRC

/******************************************************************************
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
******************************************************************************/
SNAFU2Decimal: procedure
this_ = 'SNAFU2Decimal'
rc = 0
maxRC = 0

parse arg txtLines outputFile .

loop i over txtLines
    snafuConversion = 0
    snafuDecimalValue.0 = 0
    inputStrLength = length(i)
    say time() this_ "SNAFU string" i "has" inputStrLength "digits."

    /*Calculate the positonal value. Example positon is 5^2=25 */
    counter = 0
    do while inputStrLength > 0 
        temp = i
        parse var temp nextChar+1 temp
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

    /*remove blank space and queue*/
    snafuConversion = strip(snafuConversion)
    queue snafuConversion

    say time() this_ "SNAFU number" i "has a decimal value of" snafuConversion
    say

end 

say
say time() this_ "total items in queue:" queued()

/*Delete file if it exists*/
queryFile = .stream~new(outputFile)
if queryFile~query("exists") \= " " then do
    call SysFileDelete "snafu2Decimal.txt"
    rc = 4
    maxRC = max(rc,maxRC)
    say time() this_ maxRC "Old" queryFile "deleted"
end
else 
    queryFile~close

/*create output textfile*/
outFile = .stream~new(outputFile)

/*write queued data to text file*/
do k = 1 for queued()
    parse pull outputStr
    outputStr = strip(outputStr)
    outFile~lineout(outputStr)
end k
outFile~close

say time() this_ maxRC "New data written to" outFile

maxRC = max(rc,maxRC)
return maxRC 


/*****************************************************************************
Name: AddItUp
Note: Input a list of decimal numbers. The goal is to get the sum of the
      list of numbers. Process is as follows:
            1. Get the length of the SNAFU number
            2. Parse the SNAFU number to get the first number
            3. Calculate the position # by subtracting 1 from SNAFU number 
               length. Then use that number as an exponent for 5. 
               Ex. 5^(length-1)
            4. Multiply position value by nextChar value
            5. Save the value to stem variable
            6. Sum up the stem and store
          Return the sum of all the numbers
******************************************************************************/
AddItUp: procedure
this_ = 'AddItUp'
total = 0

parse arg txtLines 

loop i over txtLines
    /*say i*/
    total = i + total 
end

say time() this_ "The total number is" total

return total


/*Decimal2SNAFU:
    Input is a list of decimal numbers
    Translate the decimal numbers to SNAFU
    return the SNAFU number
*/