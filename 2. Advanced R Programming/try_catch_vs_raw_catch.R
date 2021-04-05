## try catch function with error, warning and finallly
try_catch <- function(expr) {
  tryCatch(expr,
           error = function(e) {
             message("An error occured:\n",e)
           },
           warning = function(w) {
             message("A warning message:\n",w)
           },
           finally = message("It is done!")
           )
}

## Raw function to check if an integer is even

is_even <- function(x) {
  if (is.numeric(x) && floor(x) == x && x %% 2 == 0) { 
    ## even with three constraints it is faster than tryCatch
    TRUE
  } else {
    FALSE
  }
}

## Try - Catch
try_catch_even <- function(x) {
  tryCatch({is.numeric(x) && floor(x) == x && x %% 2 == 0},
           error = FALSE
           )
}

library(microbenchmark)

microbenchmark(sapply(LETTERS,is_even))
microbenchmark(sapply(LETTERS,try_catch_even))