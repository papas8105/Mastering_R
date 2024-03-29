library(testthat)
library(fars)


# test make_filename
test_that("Testing the make_filename function.", {
  expect_equal(basename(make_filename(2013)),"accident_2013.csv.bz2")})

test_that("Testing the make_filename function.", {
  expect_equal(basename(make_filename(2014)), "accident_2014.csv.bz2")})

test_that("Testing the make_filename function.", {
  expect_equal(basename(make_filename(2015)), "accident_2015.csv.bz2")})

# test fars_read

test_that("Testing the fars_read filename.",{
  expect_is(fars_read(make_filename(2014)),"data.frame")
})

# you can add as many tests as you like here

