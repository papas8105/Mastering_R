## load libraries

library(dplyr,warn.conflicts = F)
library(tidyr,warn.conflicts = F)

## Initialize LongitudinalData class

make_LD <- function(data) {
  data <- nest(.data = data,data = -id)
  structure(list(LD = data),class = "LongitudinalData")
}

## print method for LD class

print.LongitudinalData <- function(x) {
  paste('Longitudinal dataset with',length(unique(x$LD$id)),'subjects.')
}

## Initialize subject method

subject <- function(LD,...) UseMethod('subject')

subject.LongitudinalData <- function(object,id) {
  if (!(id %in% object$LD$id)) {
    id   <- NULL
    dat  <- NULL
  }
  else {
    ind <- which(id == object$LD$id)
    dat <- object$LD[[ind,2]]
  }
    structure(list(id = id,data = dat),class = "Subject")
}

## print method for Subject class

print.Subject <- function(subj) {
  if (is.null(subj$id)) {
    paste("NULL")
  }
  else {
    paste("Subject ID:",subj$id)
  }
}


## summary method for subject class object

summary.Subject <- function(subj) {
  if (subj$id == "NULL") {return(NULL)}
  data <- subj$data %>% group_by(visit,room) %>% 
    summarize(value = mean(value)) %>% 
    spread(room,value) %>% as.data.frame
  structure(list(id = subj$id,data = data),class = "Summary")
}

## print method for Summary class

print.Summary <- function(subj) {
  if (is.null(subj)) return(NULL)
  cat(paste("ID: ",subj$id),sep = '\n')
  print(subj$data)
}

## Visit generic function attached to Subject class

visit <- function(subject,...) UseMethod('visit')

visit.Subject <- function(subj,visit) {
  if (is.null(subj$data)) {return(NULL)}
  if (!(visit %in% 0:2)) {return("Visit must be an integer between 0 and 2!")}
  data <- subj$data %>% filter(visit == visit)
  structure(list(data = data,id = subj$id,visit = visit),class = 'Visit')
}

## Room generic function attached to Subject class
room <- function(subject,...) UseMethod('room')

room.Subject <- function(subj,room_type) {
  if (!(room_type %in% subj$data$room)) {return("Invalid room name!")}
  data <- subj$data %>% filter(room == room_type,visit == subj$visit) 
  structure(list(data = data,id = subj$id,visit = subj$visit,room = room_type),
            class = 'Room')
}

# print method for Room class

print.Room <- function(obj) {
  cat(paste("ID:",obj$id),sep = '\n')
  cat(paste("Visit:",obj$visit),sep = '\n')
  cat(paste("Room:",obj$room),sep = '\n')
}

## summary method for Room class

summary.Room <- function(obj) {
  output <- obj$data %>% select(value) %>% unlist %>% summary
  structure(list(id = obj$id,data = output),class = "Summary_Room")
}

## print method for Summary_Room

print.Summary_Room <- function(obj) {
  cat(paste("ID: ",obj$id),sep = '\n')
  print(obj$data)
}

## NOTE print and summary are already defined generic functions by the system

## Load data and write the results to a file

library(readr)
file <- "oop_output.txt"
file.create(file)
data <- read_csv("../data/MIE.csv",col_types = 'iicdi')
x    <- make_LD(data)
cat(class(x),file = file,append = T,sep = '\n')
cat(print(x),file = file,append = T,sep = '\n')
out  <- subject(x,10)
cat(print(out),file = file,append = T,sep = '\n')
out  <- subject(x,14)
cat(print(out),file = file,append = T,sep = '\n')
out  <- subject(x,54) %>% summary
capture.output(print(out),file = file,append = T)
out  <- subject(x,14) %>% summary
capture.output(print(out),file = file,append = T)
out <- subject(x, 44) %>% visit(0) %>% room("bedroom")
capture.output(print(out),file = file,append = TRUE)
out <- subject(x, 44) %>% visit(0) %>% room("bedroom") %>% summary
capture.output(print(out),file = file,append = TRUE)
out <- subject(x, 44) %>% visit(1) %>% room("living room") %>% summary
capture.output(print(out),file = file,append = TRUE)