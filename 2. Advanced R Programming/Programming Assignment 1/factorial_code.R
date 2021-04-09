## Factorial Loop Function

Factorial_loop <- function(n) {
  # check input
  if (!(is.numeric(n)) | floor(n) != n | n < 0) {
    stop("Enter a positive integer or zero!")
  } else {
    cache <- 1
    if (n == 0 | n == 1) {
      return(cache)
    }
    else {
      for (ii in 2:n) {
        cache <- cache * ii
      }
    }
  }
  return(cache)
}

## Factorial Reduce Function

Factorial_reduce <- function(n) {
  # check input
  if (!(is.numeric(n)) | floor(n) != n | n < 0) {
    stop("Enter a positive integer or zero!")
  } else {
    if (n == 0 | n == 1) return(1)
    return(Reduce(prod,2:n))
  }
}


## Factorial Functional Function

Factorial_func <- function(n) {
  # check input
  if (!(is.numeric(n)) | floor(n) != n | n < 0) {
    stop("Enter a positive integer or zero!")
  }
  if (n == 0 | n == 1) return(1)
  return(n * Factorial_func(n - 1))
}

## Factorial Memoization Function

cache <- 1

Factorial_mem <- function(n) {
  # check input
  if (!(is.numeric(n)) | floor(n) != n | n < 0) {
    stop("Enter a positive integer or zero!")
  }
  if (n == 0) return(cache[1])
  if (!is.na(cache[n])) return(cache[n]) else cache <<- `length<-`(cache,n)
  cache[n] <<- Factorial_mem(n - 1) * n
  return(cache[n])
}

## Check that the functions produce the correct results

check <- factorial(1:20)
k     <- TRUE
for (ii in 1:20) {
  k <<- k & all.equal(check[ii],Factorial_func(ii),Factorial_loop(ii),
                      Factorial_mem(ii),Factorial_reduce(ii))
}
k ## TRUE

# END