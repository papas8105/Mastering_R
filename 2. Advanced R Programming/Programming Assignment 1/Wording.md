Wording
================

The objective of Part 1 is to write a function that computes the
factorial of an integer greater than or equal to 0. Recall that the
factorial of a number n is \(n\cdot(n-1)\cdot(n - 2)\cdot...\cdot1\).
The factorial of 0 is defined to be 1. Before taking on this part of the
assignment, you may want to review the section on Functional Programming
in this course(you can also read that section here).

For this Part you will need to write four different versions of the
Factorial function:

  - Factorial\_loop: a version that computes the factorial of an integer
    using looping (such as a for loop)
  - Factorial\_reduce: a version that computes the factorial using the
    reduce() function in the purrr package. Alternatively, you can use
    the Reduce() function in the base package.
  - Factorial\_func: a version that uses recursion to compute the
    factorial.
  - Factorial\_mem: a version that uses memoization to compute the
    factorial.

After writing your four versions of the Factorial function, use the
"microbenchmark" package to time the operation of these functions and
provide a summary of their performance. In addition to timing your
functions for specific inputs, make sure to show a range of inputs in
order to demonstrate the timing of each function for larger inputs.

In order to submit this assignment, please prepare two files:

1.  factorial\_code.R: an R script file that contains the code
    implementing your classes, methods, and generics for the
    longitudinal dataset.

2.  factorial\_output.txt: a text file that contains the results of your
    comparison of the four different implementations.