## Step through the code and execute one by one line after you have sourced the 
## factorial_code.R 

library(microbenchmark)

d <- c(2,3,4,5,10,15,20,25,30,60)
w <- list()

w[[1]] <- microbenchmark(Factorial_loop(2)
                         ,Factorial_reduce(2)
                         ,Factorial_func(2)
                         ,Factorial_mem(2),times = 5000)

w[[2]] <- microbenchmark(Factorial_loop(3)
                         ,Factorial_reduce(3)
                         ,Factorial_func(3)
                         ,Factorial_mem(3),times = 5000)

w[[3]] <- microbenchmark(Factorial_loop(4)
                         ,Factorial_reduce(4)
                         ,Factorial_func(4)
                         ,Factorial_mem(4),times = 5000)

w[[4]] <- microbenchmark(Factorial_loop(5)
                         ,Factorial_reduce(5)
                         ,Factorial_func(5)
                         ,Factorial_mem(5),times = 5000)

w[[5]] <- microbenchmark(Factorial_loop(10)
                         ,Factorial_reduce(10)
                         ,Factorial_func(10)
                         ,Factorial_mem(10),times = 5000)

w[[6]] <- microbenchmark(Factorial_loop(15)
                         ,Factorial_reduce(15)
                         ,Factorial_func(15)
                         ,Factorial_mem(15),times = 5000)

w[[7]] <- microbenchmark(Factorial_loop(20)
                         ,Factorial_reduce(20)
                         ,Factorial_func(20)
                         ,Factorial_mem(20),times = 5000)

w[[8]] <- microbenchmark(Factorial_loop(25)
                         ,Factorial_reduce(25)
                         ,Factorial_func(25)
                         ,Factorial_mem(25),times = 5000)

w[[9]] <- microbenchmark(Factorial_loop(30)
                         ,Factorial_reduce(30)
                         ,Factorial_func(30)
                         ,Factorial_mem(30),times = 5000)

w[[10]] <- microbenchmark(Factorial_loop(60)
                          ,Factorial_reduce(60)
                          ,Factorial_func(60)
                          ,Factorial_mem(60),times = 5000)

file.create('factorial_output.txt')
file = file('factorial_output.txt',open = 'w+')
for (ii in 1:length(d)) {
  write(d[ii],file = file)
  write('\n--------------------------------------------------------------------------',
        file = file)
  capture.output(summary(w[[ii]]),file = file,append = TRUE)
  write('\n\n',file = file)
}
## Rewrite for already computed values for memoization
d <- c(2,3,4,5,10,15,20,25,30,60)
w <- list()

w[[1]] <- microbenchmark(Factorial_loop(2)
                         ,Factorial_reduce(2)
                         ,Factorial_func(2)
                         ,Factorial_mem(2),times = 5000)

w[[2]] <- microbenchmark(Factorial_loop(3)
                         ,Factorial_reduce(3)
                         ,Factorial_func(3)
                         ,Factorial_mem(3),times = 5000)

w[[3]] <- microbenchmark(Factorial_loop(4)
                         ,Factorial_reduce(4)
                         ,Factorial_func(4)
                         ,Factorial_mem(4),times = 5000)

w[[4]] <- microbenchmark(Factorial_loop(5)
                         ,Factorial_reduce(5)
                         ,Factorial_func(5)
                         ,Factorial_mem(5),times = 5000)

w[[5]] <- microbenchmark(Factorial_loop(10)
                         ,Factorial_reduce(10)
                         ,Factorial_func(10)
                         ,Factorial_mem(10),times = 5000)

w[[6]] <- microbenchmark(Factorial_loop(15)
                         ,Factorial_reduce(15)
                         ,Factorial_func(15)
                         ,Factorial_mem(15),times = 5000)

w[[7]] <- microbenchmark(Factorial_loop(20)
                         ,Factorial_reduce(20)
                         ,Factorial_func(20)
                         ,Factorial_mem(20),times = 5000)

w[[8]] <- microbenchmark(Factorial_loop(25)
                         ,Factorial_reduce(25)
                         ,Factorial_func(25)
                         ,Factorial_mem(25),times = 5000)

w[[9]] <- microbenchmark(Factorial_loop(30)
                         ,Factorial_reduce(30)
                         ,Factorial_func(30)
                         ,Factorial_mem(30),times = 5000)

w[[10]] <- microbenchmark(Factorial_loop(60)
                          ,Factorial_reduce(60)
                          ,Factorial_func(60)
                          ,Factorial_mem(60),times = 5000)

for (ii in 1:length(d)) {
  write(d[ii],file = file)
  write('\n--------------------------------------------------------------------------',
        file = file)
  capture.output(summary(w[[ii]]),file = file,append = TRUE)
  write('\n\n',file = file)
}
close(file)
##################################### plot for n = 10 Autoplot
# s <- microbenchmark(Factorial_loop(10),Factorial_reduce(10),Factorial_func(10)
#                    ,Factorial_mem(10))
# library(ggplot2)
# print(s)
# autoplot(s)
# library(pacman)
# rm(list = ls())
# p_unload(p_loaded,character.only = TRUE)
