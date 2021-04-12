## Recursion compute all terms until the final result
fib <- function(n) {
  stopifnot(n > 0)
  if (n == 1) {
    0
  } else if (n == 2) {
    1
  } else {
    fib(n - 1) + fib(n - 2)
  }
}

## Memoization technique
fib_tbl <- c(0,1,rep(NA,23))

fib_mem <- function(n) {
  stopifnot(n > 0)
  if (!is.na(fib_tbl[n])) {
    fib_tbl[n]
  } else {
    fib_tbl[n - 1] <<- fib_mem(n - 1)
    fib_tbl[n - 2] <<- fib_mem(n - 2)
    fib_tbl[n - 1] + fib_tbl[n - 2]
  }
}

## Benchmarks and Plots
library(purrr)
library(microbenchmark)
library(tidyverse)
## Start and record timings
fib_data <- map(1:10,function(x) microbenchmark(fib(x),times = 100)$time)
names(fib_data) <- letters[1:10]
fib_data <- as.data.frame(fib_data)
fib_data %<>% gather(num,time) %>% group_by(num) %>% 
  summarise(med_time = median(time))

memo_data <- map(1:10,function(x) microbenchmark(fib_mem(x),times = 100)$time)
names(memo_data) <- letters[1:10]
memo_data <- as.data.frame(memo_data)
memo_data %<>% gather(num,time) %>% group_by(num) %>% 
  summarise(med_time = median(time))

## Plotting
fib_data$technique <- "recursion"
memo_data$technique <- "memoization"
data <- rbind(fib_data,memo_data)
g <- ggplot(data)
g <- g + geom_point(aes(x = num,y = med_time,color = technique),cex = 2,alpha = .7)
g + xlab("fibonacci term") + ylab("median time of computation per term (nanosec)") +
  theme_bw()

## From exporting the graph we see that the computational time
## grows exponentially for the classic recursive approach "fib",
## whereas for the memoization approach the computational time 
## seems to be stabilized on a low time benchmark.