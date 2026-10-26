# Prepare national food-access deprivation estimates, 2016–2024.
# Source: INEGI, Pobreza Multidimensional 2024.
# Workbooks: 8_pm_gp_2024.xlsx and 1_pm_ar_2024.xlsx.

food_access_deprivation <- read.csv(
  "data-raw/food_access_deprivation.csv",
  colClasses = "character",
  na.strings = "NA",
  strip.white = FALSE,
  check.names = FALSE
)

# Validate structure, column order, and reference years.
expected_names <- c(
  "anio", "total", "hombres", "mujeres", "rural", "urbano",
  "edad_0_5", "edad_6_11", "edad_12_17", "edad_18_29",
  "edad_30_64", "edad_65_mas", "indigena",
  "afrodescendiente", "discapacidad"
)

stopifnot(
  identical(dim(food_access_deprivation), c(5L, 15L)),
  identical(names(food_access_deprivation), expected_names),
  !anyNA(food_access_deprivation$anio),
  !anyDuplicated(food_access_deprivation$anio),
  identical(
    food_access_deprivation$anio,
    c("2024", "2022", "2020", "2018", "2016")
  )
)

# Validate the exact missing-value pattern.
expected_missing <- matrix(
  FALSE,
  nrow = nrow(food_access_deprivation),
  ncol = ncol(food_access_deprivation),
  dimnames = dimnames(as.matrix(food_access_deprivation))
)

expected_missing[, "afrodescendiente"] <-
  food_access_deprivation$anio != "2024"

expected_missing[, "discapacidad"] <-
  food_access_deprivation$anio %in% c("2016", "2018")

stopifnot(
  identical(is.na(food_access_deprivation), expected_missing)
)

# Reject blanks, surrounding whitespace, and invalid numeric text.
source_values <- unlist(food_access_deprivation, use.names = FALSE)
source_values <- source_values[!is.na(source_values)]

stopifnot(
  all(nzchar(source_values)),
  all(source_values == trimws(source_values)),
  all(grepl("^[0-9]+([.][0-9]+)?$", source_values))
)

# Convert types without rounding, imputation, or reordering.
percentage_names <- expected_names[-1L]

food_access_deprivation$anio <-
  as.integer(food_access_deprivation$anio)

food_access_deprivation[percentage_names] <- lapply(
  food_access_deprivation[percentage_names],
  as.double
)

# Validate converted types, missing values, and percentage bounds.
stopifnot(
  is.integer(food_access_deprivation$anio),
  identical(
    food_access_deprivation$anio,
    c(2024L, 2022L, 2020L, 2018L, 2016L)
  ),
  all(vapply(
    food_access_deprivation[percentage_names],
    is.double,
    logical(1)
  )),
  identical(is.na(food_access_deprivation), expected_missing)
)

percentage_values <- unlist(
  food_access_deprivation[percentage_names],
  use.names = FALSE
)
percentage_values <- percentage_values[!is.na(percentage_values)]

stopifnot(
  all(is.finite(percentage_values)),
  all(percentage_values >= 0 & percentage_values <= 100)
)

# Save only after preparation and validation are complete.
usethis::use_data(food_access_deprivation, overwrite = TRUE)
