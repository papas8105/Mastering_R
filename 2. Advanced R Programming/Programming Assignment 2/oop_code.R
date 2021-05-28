## Libraries

if(!require(tidyr)) install.packages("tidyr")
if(!require(dplyr)) install.packages("dplyr")

## Inititialize the LongitudinalData class object

make_LD <- function(data) {
  structure(list(LD = nest(.data = data,data = -id)),class = "LongitudinalData")
}

## print method for LongitudinalData class object

print.LongitudinalData <- function(obj) {
  paste("Longitudal data with",length(obj$LD$id),"subjects")
}

## subject method for LongitudinalData class object

subject <- function(subj,id,...)  UseMethod("subject")

subject.default <- function(subj,id,...) NULL

subject.LongitudinalData <- function(obj,id) {
  if (id %in% obj$LD$id) {
    structure(list(id = id,
                 data = obj$LD$data[[which(id == obj$LD$id)]]),class = "Subject")
  } else {
    NULL
  }
}

## print method for subject class object

print.Subject <- function(subj) {
  paste("Subject ID:",subj$id)
}

## summary method for subject class object

summary.Subject <- function(subj) {
  structure(list(id = subj$id,data = subj$data %>%
                   group_by(visit,room) %>% 
                   summarise(value = mean(value)) %>%
                   pivot_wider(names_from = room,values_from = value) %>%
                   ungroup),
              class = "Summary")
}

## print method for Summary class object

print.Summary <- function(obj) {
    writeLines(text = paste("ID:",obj$id))
    obj$data
}

## visit method for subject class object

visit <- function(subj,visit,...) UseMethod("visit")

visit.default <- function(subj,visit,...) NULL

visit <- function(subj,v) {
  if (v %in% subj$data$visit) {
    structure(list(id = subj$id,visit = v,data = subj$data %>% 
                     filter(v == visit)),
              class = "Visit")
  } else {
    NULL
  }
}

## room method for subject class object

room <- function(subj,room,...) UseMethod("room")

room.default <- function(subj,room) NULL

room <- function(subj,r) {
  if (r %in% subj$data$room) {
    structure(list(id = subj$id,visit = subj$visit,room = r,data = subj$data %>% 
                     filter(room == r)),class = "Room")
  }
  else {
    NULL
  }
}

## print method for Room object class

print.Room <- function(obj) {
  cat("ID:",obj$id,"\n")
  cat("Visit:",obj$visit,"\n")
  cat("Room:",obj$room)
}

## summary method for Room class object

summary.Room <- function(subj) {
  summary(subj$data$value)
}
