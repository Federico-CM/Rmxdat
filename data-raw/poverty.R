# Prepare national multidimensional poverty estimates, 2016–2024.
# Input: CSV extract of selected INEGI tables used for package preparation.
# Preserve values, column names, row order, and missing values.
# All measures are percentages on a 0–100 scale.

poverty_raw <- read.csv(
  "data-raw/poverty.csv",
  colClasses = "character",
  na.strings = "NA",
  fileEncoding = "UTF-8",
  check.names = FALSE,
  strip.white = FALSE
)

expected_names <- c(
  "anio",
  "total",
  "hombres",
  "mujeres",
  "rural",
  "urbano",
  "edad_0_5",
  "edad_0_17",
  "edad_65_mas",
  "indigena",
  "afrodescendiente",
  "discapacidad"
)

expected_years <- c(2024L, 2022L, 2020L, 2018L, 2016L)

# Validate structure, year values, and row order.
stopifnot(
  identical(names(poverty_raw), expected_names),
  nrow(poverty_raw) == 5L,
  !anyNA(poverty_raw$anio),
  identical(poverty_raw$anio, as.character(expected_years)),
  anyDuplicated(poverty_raw$anio) == 0L
)

# Reject blank cells and unexpected surrounding whitespace.
stopifnot(
  all(vapply(
    poverty_raw,
    function(x) {
      observed <- x[!is.na(x)]
      all(nzchar(trimws(observed))) &&
        all(observed == trimws(observed))
    },
    logical(1)
  ))
)

# Check the exact expected pattern of unavailable estimates.
expected_missing <- matrix(
  FALSE,
  nrow = nrow(poverty_raw),
  ncol = ncol(poverty_raw),
  dimnames = dimnames(as.matrix(poverty_raw))
)

expected_missing[, "afrodescendiente"] <-
  poverty_raw$anio != "2024"

expected_missing[, "discapacidad"] <-
  poverty_raw$anio %in% c("2018", "2016")

stopifnot(
  identical(is.na(poverty_raw), expected_missing)
)

# Validate percentage text before conversion.
measure_names <- expected_names[-1L]

stopifnot(
  all(vapply(
    poverty_raw[measure_names],
    function(x) {
      observed <- x[!is.na(x)]
      all(grepl("^[0-9]+([.][0-9]+)?$", observed))
    },
    logical(1)
  ))
)

# Convert years to integer and percentages to double.
poverty <- poverty_raw
poverty$anio <- as.integer(poverty$anio)

poverty[measure_names] <- lapply(
  poverty[measure_names],
  as.double
)

# Validate types, missing values, and percentage bounds.
stopifnot(
  identical(poverty$anio, expected_years),
  all(vapply(poverty[measure_names], is.double, logical(1))),
  identical(is.na(poverty), expected_missing),
  all(vapply(
    poverty[measure_names],
    function(x) {
      observed <- x[!is.na(x)]
      all(is.finite(observed) & observed >= 0 & observed <= 100)
    },
    logical(1)
  ))
)

# Save only after all transformations and validation.
usethis::use_data(poverty, overwrite = TRUE)
