# Prepare national health-services deprivation estimates, 2016–2024.
# Input: CSV extract of selected INEGI tables used for package preparation.
# The CSV uses standardized age-group and Afrodescendant column names.
# Preserve numeric values, row order, and missing values.
# All measures are percentages on a 0–100 scale.

health_service_access_raw <- read.csv(
  "data-raw/health_service_access.csv",
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
  identical(names(health_service_access_raw), expected_names),
  nrow(health_service_access_raw) == 5L,
  !anyNA(health_service_access_raw$anio),
  identical(
    health_service_access_raw$anio,
    as.character(expected_years)
  ),
  anyDuplicated(health_service_access_raw$anio) == 0L
)

# Reject blank cells and unexpected surrounding whitespace.
stopifnot(
  all(vapply(
    health_service_access_raw,
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
  nrow = nrow(health_service_access_raw),
  ncol = ncol(health_service_access_raw),
  dimnames = dimnames(as.matrix(health_service_access_raw))
)

expected_missing[, "afrodescendiente"] <-
  health_service_access_raw$anio != "2024"

expected_missing[, "discapacidad"] <-
  health_service_access_raw$anio %in% c("2018", "2016")

stopifnot(
  identical(is.na(health_service_access_raw), expected_missing)
)

# Validate percentage text before conversion.
measure_names <- expected_names[-1L]

stopifnot(
  all(vapply(
    health_service_access_raw[measure_names],
    function(x) {
      observed <- x[!is.na(x)]
      all(grepl("^[0-9]+([.][0-9]+)?$", observed))
    },
    logical(1)
  ))
)

# Convert years to integer and percentages to double.
health_service_access <- health_service_access_raw
health_service_access$anio <- as.integer(health_service_access$anio)

health_service_access[measure_names] <- lapply(
  health_service_access[measure_names],
  as.double
)

# Validate types, missing values, and percentage bounds.
stopifnot(
  identical(health_service_access$anio, expected_years),
  all(vapply(
    health_service_access[measure_names],
    is.double,
    logical(1)
  )),
  identical(is.na(health_service_access), expected_missing),
  all(vapply(
    health_service_access[measure_names],
    function(x) {
      observed <- x[!is.na(x)]
      all(is.finite(observed) & observed >= 0 & observed <= 100)
    },
    logical(1)
  ))
)

# Save only after all transformations and validation.
usethis::use_data(health_service_access, overwrite = TRUE)
