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

puzzle_input_file = 'puzzleInput.txt'
decimal_input_file = 'snafu2Decimal.txt'

/*get all the numbers and not just 9 by rexx default*/
numeric digits 24

/*Get this program's name*/
parse source system invocation full_program_path
full_program_path = reverse(full_program_path)
parse var full_program_path 'xer.' this_ '/' .
this_ = reverse(this_)

/*remove extraneous space from filename*/
puzzle_input_file = strip(puzzle_input_file)

/*check if the file exists*/
call verify_file puzzle_input_file 
parse var result called_rc retun_msg

/*check rc*/
if called_rc > 0 then do
    say time() this_ called_rc return_msg
    exit
end
else say time() this_ called_rc retun_msg


/*read in the puzzle file into an array*/
say time() this_ "Reading" puzzle_input_file "..."
say

input_file = .stream~new(puzzle_input_file)
lines = input_file~arrayin

if rc > 0 then do
    say time() this_ rc "Error reading file"
    exit maxRC
end 

input_file~close


say time() this_ "Converting SNAFU numbers to decimal..."
say


/*Convert the SNAFU numbers to decimal*/
call SNAFU2Decimal lines 
if rc > 4 then do
    maxRC = max(rc, maxRC)
    say time() this_ rc "Unable to generate SNAFU2DECIMAL list"
    exit maxRC
end

/*read the converted decimal numbers from the array*/
say time() this_ "Reading decimal numbers from array..."
say

/*get the sum of all numbers converted from SNAFU*/
call AddItUp result

/*Convert the sum to a snafu number*/
call Decimal2SNAFU result


exit maxRC


/******************************************************************************
Name: verify_file
Note: Ensure that the text file exists. If not return 8
******************************************************************************/
verify_file: procedure 
this_ = 'verify_file'
rc = 0
max_rc = 0

parse arg file_name .

/* remove extraneous space*/
file_name = strip(file_name) 

/*check if the file exists*/
query_file = .stream~new(file_name)
if query_file~query("exists") == " " then do
    rc = 8
    max_rc = max(rc, max_rc)
    return_string = max_rc "Error:" file_name "does not exist"
end
else do
    rc = 0
    max_rc = max(rc, max_rc)
    return_string = max_rc "Success:" file_name "file exists"
    query_file~close
end
return return_string

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
        6. Sum up the stem and store in an array
        Return a array with the SNAFU numbers converted to decimal.
******************************************************************************/
SNAFU2Decimal: procedure
this_ = 'SNAFU2Decimal'
rc = 0
maxRC = 0

snafu_concersion_array = .array~new() 

parse arg txt_lines .

loop i over txt_lines
    snafu_conversion = 0
    snafu_decimal_value.0 = 0
    input_str_length = length(i)
    /*say time() this_ "SNAFU string" i "has" input_str_length "digits."*/

    /*Calculate the positonal value. Example positon is 5^2=25 */
    counter = 0
    temp = i
    do while input_str_length > 0 
        parse var temp nextChar+1 temp

        /*say nextChar*/
        position_Value = 5 ** (input_str_length - 1)
        counter = counter + 1
        snafu_decimal_value.0 = counter

        /*Convert the - and = to -1 and -2 respectively*/
        if nextChar == '-' then
            snafu_decimal_value.counter = position_value * -1 
        else if nextChar == '=' then
            snafu_decimal_value.counter = position_value * -2
        else
            snafu_decimal_value.counter = position_value * nextChar

        input_str_length = input_str_length - 1 
    end 

    /*Get sum of each position to complete conversion to decimal*/
    do j = 1 to snafu_decimal_value.0 
        snafu_conversion = snafu_decimal_value.j + snafu_conversion
    end

    /*remove blank space and queue*/
    snafu_conversion = strip(snafu_conversion)
    snafu_concersion_array~append(snafu_conversion) 
    
    /*
    say time() this_ "SNAFU number" i "has a decimal value of" snafu_conversion
    say
    */

end 

return snafu_concersion_array


/*****************************************************************************
Name: AddItUp
Note: Input a list of decimal numbers. The goal is to get the sum of the
      list of numbers. Process is as follows:
            1. Simple loop to add the numbers. May move items from main exec
               here later.
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


/*****************************************************************************
Name: Decimal2SNAFU
Note: Input a decimal number. The goal is to convert it to SNAFU number
******************************************************************************/
Decimal2SNAFU: procedure
this_ = 'Decimal2SNAFU'
rc = 0
maxRC = 0

exponentNum = 0
exponentCounter = 0
total = 0
snafuNumber.0 = 0
previousValue = 0

parse arg decimalSum .

/*Find the highest exponent Value*/
do forever 
    
    exponentNum = 5 ** exponentCounter
    total = total + (2 * exponentNum) 

    if total <= decimalSum then 
        exponentCounter = exponentCounter + 1
    else leave
end 


/*Capture total number of exponenets*/
snafuNumber.0 = exponentCounter
sortingArray = .array~new(4) 

/*Iterate over each exponent number*/
do loopCounter = exponentCounter to 0 by -1
    
    /*clear array*/
    sortingArray~empty
    currentValue = ''

    /*Capture each value from 2 to -2*/
    do innerLoopCount = 2 to -2 by -1
        tempValue = ((5 ** loopCounter) * innerLoopCount) + previousValue
        /*say time() this_ "TempValue iteration #" innerLoopCount "is,
                            "tempValue
        */

        if decimalSum > tempValue then
            difference =  decimalSum - tempValue
        else difference = tempValue - decimalSum

        if currentValue = '' then do
            currentValue = difference
            totalValue = tempValue
            snafuNumber.loopCounter = innerLoopCount
        end
        else if difference < currentValue then do
            currentValue = difference
            totalValue = tempValue
            snafuNumber.loopCounter = innerLoopCount
        end
        else nop


        /*say time() this_ "Difference is" difference*/

       /*sortingArray~insert(difference)*/
    end
    previousValue = totalValue
end

/*show value on array*/
say
say time() this_ "Answer Below"
do i = exponentCounter to 0 by -1
    say time() this_ "snafuNumber."i "is" snafuNumber.i
end

return 