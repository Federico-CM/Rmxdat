# Prepare national extreme poverty estimates, 2016–2024.
# Input: CSV extract of selected INEGI tables used for package preparation.
# Preserve column names, values, row order, and missing values.
# All measures are percentages on a 0–100 scale.

extreme_poverty_raw <- read.csv(
  "data-raw/extreme_poverty.csv",
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
  identical(names(extreme_poverty_raw), expected_names),
  nrow(extreme_poverty_raw) == 5L,
  !anyNA(extreme_poverty_raw$anio),
  identical(extreme_poverty_raw$anio, as.character(expected_years)),
  anyDuplicated(extreme_poverty_raw$anio) == 0L
)

# Reject blank cells and unexpected surrounding whitespace.
stopifnot(
  all(vapply(
    extreme_poverty_raw,
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
  nrow = nrow(extreme_poverty_raw),
  ncol = ncol(extreme_poverty_raw),
  dimnames = dimnames(as.matrix(extreme_poverty_raw))
)

expected_missing[, "afrodescendiente"] <-
  extreme_poverty_raw$anio != "2024"

expected_missing[, "discapacidad"] <-
  extreme_poverty_raw$anio %in% c("2018", "2016")

stopifnot(
  identical(is.na(extreme_poverty_raw), expected_missing)
)

# Validate percentage text before conversion.
measure_names <- expected_names[-1L]

stopifnot(
  all(vapply(
    extreme_poverty_raw[measure_names],
    function(x) {
      observed <- x[!is.na(x)]
      all(grepl("^[0-9]+([.][0-9]+)?$", observed))
    },
    logical(1)
  ))
)

# Convert years to integer and percentages to double.
extreme_poverty <- extreme_poverty_raw
extreme_poverty$anio <- as.integer(extreme_poverty$anio)

extreme_poverty[measure_names] <- lapply(
  extreme_poverty[measure_names],
  as.double
)

# Validate types, missing values, and percentage bounds.
stopifnot(
  identical(extreme_poverty$anio, expected_years),
  all(vapply(extreme_poverty[measure_names], is.double, logical(1))),
  identical(is.na(extreme_poverty), expected_missing),
  all(vapply(
    extreme_poverty[measure_names],
    function(x) {
      observed <- x[!is.na(x)]
      all(is.finite(observed) & observed >= 0 & observed <= 100)
    },
    logical(1)
  ))
)

# Save only after all transformations and validation.
usethis::use_data(extreme_poverty, overwrite = TRUE)
