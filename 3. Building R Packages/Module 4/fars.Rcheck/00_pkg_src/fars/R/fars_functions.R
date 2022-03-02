#' Motor Vehicle Traffic Injuries
#'
#'@importFrom tidyr spread_
#'@importFrom dplyr bind_rows
#'@importFrom dplyr filter_
#'@importFrom dplyr group_by_
#'@importFrom dplyr mutate_
#'@importFrom dplyr select_
#'@importFrom dplyr summarize_
#'@importFrom dplyr tbl_df
#'@importFrom graphics points
#'@importFrom magrittr "%>%"
#'@importFrom maps map
#'@importFrom readr read_csv
#'
#'

#'@source Motor Vehicle Traffic Injuries file
#'
#' This function reads data from .csv file, stored on disk, from the \strong{US
#' National Highway Traffic Safety Administration's} \emph{Fatality Analysis
#' Reporting System} (FARS), which is a nationwide census, providing the
#' American public yearly data, regarding fatal injuries suffered in motor
#' vehicle traffic crashes.
#'
#' @details For more information, see:
#' \itemize{
#'   \item{\url{https://www.nhtsa.gov/research-data/fatality-analysis-reporting-system-fars}}
#'   \item{\url{https://en.wikipedia.org/wiki/Fatality_Analysis_Reporting_System}}
#' }
#'
#' @param filename path to load Fars Data.
#  @return a tibble data frame of Accidental Injuries
#'
#' @examples \dontrun{
#'           filename <- list.files(system.file("extdata", package = "Fars_Assignment"))
#'           fars_read(filename)
#'           }
#'@export

fars_read <- function(filename) {
  if(!file.exists(filename))
    stop("file '", filename, "' does not exist")
  data <- suppressMessages({
    readr::read_csv(filename, progress = FALSE)
  })
  dplyr::tbl_df(data)
}

#'make_filename: Print file Name
#'
#'
#'Print file name for a particular year.
#'
#'@param year to load the data for that year.
#'
#'
#'@examples \dontrun{make_filename(2013)}
#'
#'@return a filename
#'
#'@export

make_filename <- function(year) {
  year <- as.integer(year)
  sprintf("accident_%d.csv.bz2", year)
  system.file("extdata",
              sprintf("accident_%d.csv.bz2", year),
              package = "fars",
              mustWork = TRUE)
}

#'fars_read_years:Load accidents by Year & Month.
#'
#'Extract the month from the years arg passed to function.
#'And check if file exists for those months.
#'If it doesn't exist throw a warning "invalid year".
#'
#'Ancillary function used by \code{fars_summarize_years}
#'
#'@param years a vector with list of years
#'@return A data.frame with number of accidents by years summarized by month
#'
#'@examples
#'\dontrun{
#'    years <- c(2013,2015)
#'    fars_read_years(years)
#'}
#'@export

fars_read_years <- function(years) {
  lapply(years, function(year) {
    file <- make_filename(year)
    print(file)
    tryCatch({
      dat <- fars_read(file)
      print(dat)
      dplyr::mutate(dat, year = year) %>%
        dplyr::select("MONTH", "year")
    }, error = function(e) {
      warning("invalid year: ", year)
      return(NULL)
    })
  })
}

#'fars_summarize_years: No.of Accidents per Month/Year
#'
#'Retrieve the files based on the year.
#'group by year and month. Get n records per year .
#'Summarize No of records based on years and Month.
#'
#'@param years A vector with a list of years to summarize by.
#'@return a data.frame with number of accidents by years summarized by month
#'
#'@examples
#'\dontrun{fars_summarize_years(c(2013,2015))}
#'@export

fars_summarize_years <- function(years) {
  dat_list <- fars_read_years(years)
  dplyr::bind_rows(dat_list) %>%
    dplyr::group_by("year", "MONTH") %>%
    dplyr::summarize(n = "n()") %>%
    tidyr::spread("year", "n")
}

#'fars_map_state: Displays a plot with a state map including the accidents location by year
#'Get data based on year, state number.
#'filter records based on state num passed.
#'If \code{state.num} does not exist throws message no accidents for that state.
#'else generate plot with no null values for Logitude > 900 and latitude > 90.
#'Plots based on States and for a particular year. x axis Logitude, y axis Latitude. No null values.
#'
#'@param state.num An Integer with the State Code
#'\tabular{cc}{
#'   \strong{State Code} \tab \strong{State Name}    \cr
#'   01 \tab  Alabama              \cr
#'   02 \tab  Alaska               \cr
#'   04 \tab  Arizona              \cr
#'   05 \tab  Arkansas             \cr
#'   06 \tab  California           \cr
#'   08 \tab  Colorado             \cr
#'   09 \tab  Connecticut          \cr
#'   10 \tab  Delaware             \cr
#'   11 \tab  District of Columbia \cr
#'   12 \tab  Florida              \cr
#'   13 \tab  Georgia              \cr
#'   15 \tab  Hawaii               \cr
#'   16 \tab  Idaho                \cr
#'   17 \tab  Illinois             \cr
#'   18 \tab  Indiana              \cr
#'   19 \tab  Iowa                 \cr
#'   20 \tab  Kansas               \cr
#'   21 \tab  Kentucky             \cr
#'   22 \tab  Louisiana            \cr
#'   23 \tab  Maine                \cr
#'   24 \tab  Maryland             \cr
#'   25 \tab  Massachusetts        \cr
#'   26 \tab  Michigan             \cr
#'   27 \tab  Minnesota            \cr
#'   28 \tab  Mississippi          \cr
#'   29 \tab  Missouri             \cr
#'   30 \tab  Montana              \cr
#'   31 \tab  Nebraska             \cr
#'   32 \tab  Nevada               \cr
#'   33 \tab  New Hampshire        \cr
#'   34 \tab  New Jersey           \cr
#'   35 \tab  New Mexico           \cr
#'   36 \tab  New York             \cr
#'   37 \tab  North Carolina       \cr
#'   38 \tab  North Dakota         \cr
#'   39 \tab  Ohio                 \cr
#'   40 \tab  Oklahoma             \cr
#'   41 \tab  Oregon               \cr
#'   42 \tab  Pennsylvania         \cr
#'   43 \tab  Puerto Rico          \cr
#'   44 \tab  Rhode Island         \cr
#'   45 \tab  South Carolina       \cr
#'   46 \tab  South Dakota         \cr
#'   47 \tab  Tennessee            \cr
#'   48 \tab  Texas                \cr
#'   49 \tab  Utah                 \cr
#'   50 \tab  Vermont              \cr
#'   51 \tab  Virginia             \cr
#'   52 \tab  Virgin Islands       \cr
#'   53 \tab  Washington           \cr
#'   54 \tab  West Virginia        \cr
#'   55 \tab  Wisconsin            \cr
#'   56 \tab  Wyoming
#' }
#'@param year A string, or an integer, with the input \code{year}
#'
#'@examples
#'\dontrun{fars_map_state(21,2013)}
#'@export

fars_map_state <- function(state.num, year) {
  filename <- make_filename(year)
  data <- fars_read(filename)
  state.num <- as.integer(state.num)

  if(!(state.num %in% unique(data$STATE)))
    stop("invalid STATE number: ", state.num)
  data.sub <- dplyr::filter_(data, .dots = paste0("STATE==", state.num))
  if(nrow(data.sub) == 0L) {
    message("no accidents to plot")
    return(invisible(NULL))
  }
  is.na(data.sub$LONGITUD) <- data.sub$LONGITUD > 900
  is.na(data.sub$LATITUDE) <- data.sub$LATITUDE > 90
  with(data.sub, {
    maps::map("state", ylim = range(LATITUDE, na.rm = TRUE),
              xlim = range(LONGITUD, na.rm = TRUE))
    graphics::points(LONGITUD, LATITUDE, pch = 46)
  })
}
