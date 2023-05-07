#!/usr/bin/env rexx
/*REXX
    adventOfCodeDay01
    https://adventofcode.com/2022/day/1
    Find the Elf carrying the most Calories. How many total Calories is that Elf
    carrying? Get the sum of the top 3 elves calories. 

    Gotta learn how to use ooREXX objects. Elves probably could have been a classs
*/

/*trace i*/
rc = 0
max_rc = 0
puzzle_input_file = 'puzzleInput.txt'
elf.0 = 0
count = 0
total_calories = 0
largest_amount_of_calories = 0
top_three_elves = .array~new()
sum_of_calories_for_three_elves = 0


/*Get this program's name*/
parse source system invocation full_program_path
full_program_path = reverse(full_program_path)
parse var full_program_path 'xer.' this_ '/' .
this_ = reverse(this_)

/*verify file exists*/
call verify_file puzzle_input_file 
parse var result called_rc return_msg

/*check verify_file return code*/
if called_rc > 0 then do
    say time() this_ called_rc return_msg
    max_rc = max(called_rc, rc)
    exit max_rc
end
else do
    say time() this_ called_rc return_msg
    max_rc = max(called_rc, rc)
    exit max_rc
end
say

/*read in the file*/
input_file = .stream~new(puzzle_input_file)
input_file~open


/*get calories*/
do i = 1 to input_file~lines
   
    line = strip(substr(input_file~linein,1,9))


    /*If the line is blank or end of file, process the previous strings*/
    if line == "" |,
       i == input_file~lines then do
        say time() this_ total_calories "total calories placed in this bag. Let's give it to an elf!"

        /*create the first elf*/
        count = count + 1
        elf.0 = count

        say time() this_ "Hello," elf.count "your bag of" total_calories "calories is ready!"
        say 

        /*Store the total calories the elf is carrying*/
        elf.count.total = total_calories

        /*reset total calories for the next elf*/
        total_calories = 0 
    end

    else total_calories = total_calories + line

end

say time() this_ "Total elves created" elf.0
input_file~close 


/* Who is carrying the most calories? How much is in the bag?*/
do i = 1 to elf.0

    /*build array for top three elves. easier to sort for now*/
    top_three_elves~append(elf.i.total)
    
    /*compare to see who has the most calories in their bag*/
    if elf.i.total > largest_amount_of_calories then do
        largest_amount_of_calories = elf.i.total
        winning_elf = i
    end

end

say time() this_ "The elf carrying the most calories is" elf.winning_elf "with" largest_amount_of_calories
drop elf. total_calories

/*Find top three elves and get sum of their calories*/
top_three_elves~sortWith(.NumericComparator~new)

/*
do number over top_three_elves
    say time() this_ "checking if this is sorted:" number
end
*/


total_items = top_three_elves~items
top_three_range = total_items - 2  /*subtracting to get top three*/

/*sum it up*/
do i = top_three_range to total_items
    sum_of_calories_for_three_elves = top_three_elves[i] + sum_of_calories_for_three_elves
end

say time() this_ "Sum of calories for the top three elves is" sum_of_calories_for_three_elves
say

exit max_rc


/******************************************************************************
Name: verify_file
Note: Ensure that the text file exists. If not return 8
******************************************************************************/
verify_file: procedure

this_ = 'verify_file'
rc = 0
max_rc = 0
/*trace i*/

parse arg file_name .

/* remove extraneous space*/
file_name = strip(file_name) 

/*check if the file exists*/
query_file = .stream~new(file_name)
if query_file~query("exists") == "" then do
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