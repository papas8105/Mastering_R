#' This function reads a filename  and returns a tibble data frame object. 
#' The filename inputs are provided by the US National Highway Traffic 
#' Safety Administration's Fatality Analysis Reporting System, which is a 
#' nationwide census providing the American public yearly data regarding fatal 
#' injuries suffered in motor vehicle traffic crashes. In case a wrong input 
#' is provided an error is returned from readr's read_csv function.
#' 
#' @param filename input of type character, the name of the file corresponding to a year
#' 
#' @return data of type table data frame
#' 
#' @details No confirmation is printed to the console!
#' 
#' @importFrom readr read_csv
#' 
#' @importFrom dplyr tbl_df
#' 
#' @examples 
#' 
#' \dontrun{fars_read(filename = "accident_2013.csv.bz2")}
#' 
#' \dontrun{fars_read(filename = "accident_2009.csv.bz2)}
#' 
#' @keywords  roxygen2 vignette writing
#' 
#' @export

fars_read <- function(filename) {
  if(!file.exists(filename))
    stop("file '", filename, "' does not exist")
  data <- suppressMessages({
    readr::read_csv(filename, progress = FALSE)
  })
  dplyr::tbl_df(data)
}

#' This is a helper function for fars_read, it receives a character/numeric type input 
#' which represents a year and returns the filename in the format to be read as input 
#' by the fars_read function.
#' 
#' @param year a character/numeric type input which represents a year
#' 
#' @return the string of the filename for a specific year: format \eqn{\to} accident_"YEAR".csv.bz2
#' 
#' @examples 
#' 
#' \dontrun{make_filename("1981")}
#' 
#' @export

make_filename <- function(year) {
  year <- as.integer(year)
  sprintf("accident_%d.csv.bz2", year)
}

#' This functions receives as input a list of years of type character/numeric
#' and returns the corresponding file names as inputs for the fars_read function to 
#' return multiple outputs. It is an extension of the make_filename function which
#' creates a single output and makes use of it. In case of an invalid year input i.e.
#' year outside of range of the data time scope or totally wrong input, you get a warning
#' message with the NULL output.
#' 
#' @param years a list of years in character/numeric format
#' 
#' @return a list of filenames suitable for fars_read function
#' 
#' @importFrom magrittr %>%
#'
#' @importFrom dplyr mutate select
#'
#' @importFrom rlang .data
#' 
#' @examples 
#' 
#' \dontrun{make_filename(list(1999,2009,2019))}
#' 
#' @export

fars_read_years <- function(years) {
  lapply(years, function(year) {
    file <- make_filename(year)
    tryCatch({
      dat <- fars_read(file)
      dplyr::mutate(dat, year = year) %>% 
        dplyr::select(MONTH, year)
    }, error = function(e) {
      warning("invalid year: ", year)
      return(NULL)
    })
  })
}

#' This function receives as inputs the years for which you would like to see a summary of each year's 
#' dataset in terms of accidents that occurred per month. The rows of the output represent the month
#' and the columns the years you would like to investigate and each cell provides the number of 
#' accidents occurred in a specific month of an input year.
#' 
#' @param years list or single inputs of years of type character or numeric.
#'
#' @return The return will be a data.frame with years in columns and months in rows. Each row represent
#'         the number of accidents.
#'
#' @importFrom tidyr spread
#'
#' @importFrom dplyr bind_rows group_by summarize n
#'
#' @importFrom magrittr %>%
#'
#' @importFrom rlang .data
#'
#' @examples
#' 
#' \dontrun{fars_summarize_years(years = list(2001,2005,2009,2013,2019))}
#'
#' @export

fars_summarize_years <- function(years) {
  dat_list <- fars_read_years(years)
  dplyr::bind_rows(dat_list) %>% 
    dplyr::group_by(year, MONTH) %>% 
    dplyr::summarize(n = n()) %>%
    tidyr::spread(year, n)
}

#' This function visualizes the accidents per year given a year data and a state number. The 
#' plot it provides as output is the map of the input state with points on top of it, showing 
#' the places of accidents during the year you specified as input. If the state number is invalid
#' an error is returned and if the number of accidents is 0 you get a message informing 
#' you of the good news!
#' 
#' @param state.num the number of the state
#' 
#' @param year the character/numeric input of the year you are interested in
#' 
#' @return a map of the state you specified with markers of accidents in the year you specified
#' 
#' @importFrom graphics points
#'
#' @importFrom maps map
#'
#' @importFrom dplyr filter
#'
#' 
#' @examples 
#' \dontrun{fars_map_state(state.num = 10,year = 2009)}
#' \dontrun{fars_map_state(state.num = 10,year = 2015)}
#' \dontrun{fars_map_state(state.num = 52,year = 1999)}
#' \dontrun{fars_map_state(state.num = 100,year = 1999)}
#' 
#' @export

fars_map_state <- function(state.num, year) {
  filename <- make_filename(year)
  data <- fars_read(filename)
  state.num <- as.integer(state.num)
  
  if(!(state.num %in% unique(data$STATE)))
    stop("invalid STATE number: ", state.num)
  data.sub <- dplyr::filter(data, STATE == state.num)
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
