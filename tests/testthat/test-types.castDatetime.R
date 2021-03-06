library(stringr)
library(tableschema.r)
library(testthat)
library(foreach)
library(lubridate)
library(config)

context("types.castDatetime")

datetime <- function(year, month, day, hour=0, minute=0, second=0){
  
  return(lubridate::as_date(lubridate::make_datetime(year, month, day, hour, minute, second,tz = "UTC")))
}

# Constants

TESTS <- list(
  
  list("default", datetime(2014, 1, 1, 6), datetime(2014, 1, 1, 6)),
  
  list("default", "2014-01-01T06:00:00Z", lubridate::make_datetime(2014, 1, 1, 6)),
  
  list("default", "Mon 1st Jan 2014 9 am", config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  
  list("default", "invalid", config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  
  list("default", TRUE, config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  
  list("default", "", config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  
  list("any", datetime(2014, 1, 1, 6), datetime(2014, 1, 1, 6)),
  
  #["any", "10th Jan 1969 9 am", datetime(1969, 1, 10, 9)),
  
  list("any", "invalid", config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  
  list("any", TRUE, config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  
  list("any", "", config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  
  list("%y/%m/%d %H:%M", datetime(2006, 11, 21, 16, 30), datetime(2006, 11, 21, 16, 30)),
  
  list("%d/%m/%y %H:%M", "21/11/06 16:30", lubridate::make_datetime(2006, 11, 21, 16, 30)),
  
  list("%H:%M %d/%m/%y", "21/11/06 16:30", config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  
  list("%d/%m/%y %H:%M", "invalid", config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  
  list("%d/%m/%y %H:%M", TRUE, config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  
  list("%d/%m/%y %H:%M", "", config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  
  list("invalid", "21/11/06 16:30", config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  
  # Deprecated
  list("fmt:%d/%m/%y %H:%M", datetime(2006, 11, 21, 16, 30), datetime(2006, 11, 21, 16, 30)),
  
  list("fmt:%d/%m/%y %H:%M", "21/11/06 16:30", lubridate::make_datetime(2006, 11, 21, 16, 30)),
  
  list("fmt:%H:%M %d/%m/%y", "21/11/06 16:30", config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  
  list("fmt:%d/%m/%y %H:%M", "invalid", config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  
  list("fmt:%d/%m/%y %H:%M", TRUE, config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r"))),
  
  list("fmt:%d/%m/%y %H:%M", "", config::get("ERROR", file = system.file("config/config.yml", package = "tableschema.r")))
  
)

# Tests

foreach(j = seq_along(TESTS) ) %do% {
  
  TESTS[[j]] <- setNames(TESTS[[j]], c("format", "value", "result"))
  
  test_that(str_interp('format "${TESTS[[j]]$format}" should check "${TESTS[[j]]$value}" as "${TESTS[[j]]$result}"'), {
    
    expect_equal(types.castDatetime(TESTS[[j]]$format, TESTS[[j]]$value), TESTS[[j]]$result)
  })
}
