where <- function(x) {
  if (!is.character(x)) stop("You should have entered a character!")
  X <- NULL
  for (envirs in search()) {
    if (x %in% ls(as.environment(envirs))) {
      X <- 1
      print(envirs)}}
  if (is.null(X)) {print("does not exist!")}}

parent <- function(envir) {
  if (!identical(envir,".Globalenv")) envir <- paste("package:",envir,sep  = '')
  envir <- parent.env(as.environment(envir))
  envir
}
