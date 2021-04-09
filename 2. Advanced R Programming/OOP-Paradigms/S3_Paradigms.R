## Everything in R is an object
## There are two types the base objects and the OO objects (object oriented)

class(2)
class("is in this session")
class(class)
class(sum)

#### ---> "numeric","character","function"

## with structure we can define metadata attributes or a class for an object

special_num_1 <- structure(1,class = "special_number")
class(special_num_1)
special_num_2 <- structure("George",meta = "this is me! A meta info!")
class(special_num_2) <- "me"

#### ---> "special number"

## define a class named shape_S3

shape_S3 <- function(side_lengths) {
  structure(list(side_lengths = side_lengths),
            class = "shape_S3")
}

## Define objects of class shape_S3

square_4 <- shape_S3(c(4,4,4,4))
class(square_4) #### ---> "shape_S3"
triangle_3 <- shape_S3(c(3,3,3))
class(triangle_3) #### ---> "shape_S3"

## create a method for the class shape_S3

is_square <- function(obj) UseMethod("is_square")

## the generic function is set and it will be specialized to work with shape_S3
## in order to be dispatched

is_square.shape_S3 <- function(obj) {
  length(obj$side_lengths) == 4 && 
    obj$side_lengths[1] == obj$side_lengths[2] && 
    obj$side_lengths[2] == obj$side_lengths[3] && 
    obj$side_lengths[3] == obj$side_lengths[4]
}

## do some tests
is_square(square_4)
is_square(triangle_3)

## define default state if the input for is_square is not a shape_S3 class
is_square.default <- function(obj) {
  NA
}

## Tests
is_square("square")   #---> NA
is_square(c(1,1,1,1)) #---> TRUE

## Let's print square_4

print(square_4)

## We don't want the previous result so we will create a generic print function
## to work with shape_S3
print.shape_S3 <- function(obj) {
  if (length(obj$side_lengths) == 3) {
    paste("A triangle with side lengths of",obj$side_lengths[1],
          obj$side_lengths[2],"and",obj$side_lengths[3])
  }
  else if (length(obj$side_lengths) == 4) {
    if (is_square(obj)) {
      paste("A square with four sides of length",obj$side_lengths[1])
    }
    else {
      paste("A quadrilateral with side lengths of",obj$side_lengths[1],
            obj$side_lengths[2],obj$side_lengths[3],"and",obj$side_lengths[4])
    }
  }
  else {
    paste("A shape with",length(obj$side_lengths),"slides.")
  }
}

print(square_4)
print(triangle_3)
print(shape_S3(c(10,10,25,40,1)))
print(shape_S3(c(1,2,3,4)))

## find methods associated with the print generic function

head(methods(print),10)

## Inheritance
class(square_4)
class(square_4) <- c("shape_S3","square")
class(square_4)
inherits(square_4,"square")

## Construct a polygon object x and y are the corresponding coordinates

make_poly <- function(x,y) {
  if (length(x) != length(y)) {
    stop("'x' and 'y' should be the same length")
  }
  object <- list(xcoord = x,ycoord = y)
  class(object) <- "polygon"
  object
}

## Define print method for polygon
print.polygon <- function(x,...) {
  cat("a polygon with",length(x$xcoord),"vertices\n")
  invisible(x)
}

## Define summary method for polygon

summary.polygon <- function(object,...) {
  object <- list(rng.x = range(object$xcoord),rng.y = range(object$ycoord))
  class(object) <- "summary_polygon"
  object
}

## print method for summary.polygon objects
## x is an object of class "summary_polygon"
print.summary_polygon <- function(x,...) {
  cat("x:",x$rng.x[1],"-->",x$rng.x[2],"\n")
  cat("y:",x$rng.y[1],"-->",x$rng.y[2],"\n")
  invisible(x)
}

## construct a new "polygon" object
x <- make_poly(1:4,c(1,5,2,1))
print(x)
out <- summary(x)
class(out)
print(out)
summary(x)
