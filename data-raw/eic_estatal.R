# Selected state-level population characteristics, EIC 2025.
# Source: INEGI, Encuesta Intercensal 2025.
# Principales resultados por localidad de 50 000 y más habitantes.
# https://www.inegi.org.mx/programas/eic/2025/#datos_abiertos
# Download date: 2026-10-19.
#
# Input: user-supplied extract containing 32 state records and
# 10 selected source variables. Preserve names, values, and row order.

eic_estatal <- read.csv(
  "data-raw/eic_estatal.csv",
  colClasses = "character",
  fileEncoding = "UTF-8",
  check.names = FALSE,
  na.strings = "",
  strip.white = TRUE
)

expected_names <- c(
  "NOM_ENT", "CVE_ENT", "POBTOT", "MEDIANA_POBTOT",
  "POB0_14", "POB15_64", "POB65_MAS",
  "PCN_POB_IND", "PCN_P3YM_HLI", "PCN_POB_AFRO"
)

stopifnot(
  identical(names(eic_estatal), expected_names),
  nrow(eic_estatal) == 32L,
  !anyNA(eic_estatal),
  all(vapply(
    eic_estatal,
    function(x) all(nzchar(trimws(x))),
    logical(1)
  )),
  anyDuplicated(eic_estatal$NOM_ENT) == 0L,
  anyDuplicated(eic_estatal$CVE_ENT) == 0L,
  identical(sort(eic_estatal$CVE_ENT), sprintf("%02d", 1:32))
)

count_columns <- c(
  "POBTOT", "POB0_14", "POB15_64", "POB65_MAS"
)

decimal_columns <- c(
  "MEDIANA_POBTOT", "PCN_POB_IND",
  "PCN_P3YM_HLI", "PCN_POB_AFRO"
)

# Validate numeric text before conversion.
stopifnot(
  all(vapply(
    eic_estatal[count_columns],
    function(x) all(grepl("^[0-9]+$", x)),
    logical(1)
  )),
  all(vapply(
    eic_estatal[decimal_columns],
    function(x) all(grepl("^[0-9]+(\\.[0-9]+)?$", x)),
    logical(1)
  ))
)

numeric_columns <- expected_names[-c(1, 2)]

eic_estatal[numeric_columns] <- lapply(
  eic_estatal[numeric_columns],
  as.double
)

percentage_columns <- c(
  "PCN_POB_IND", "PCN_P3YM_HLI", "PCN_POB_AFRO"
)

stopifnot(
  all(vapply(
    eic_estatal[numeric_columns],
    function(x) all(is.finite(x) & x >= 0),
    logical(1)
  )),
  all(eic_estatal$POBTOT > 0),
  all(eic_estatal$MEDIANA_POBTOT <= 130),
  all(vapply(
    eic_estatal[percentage_columns],
    function(x) all(x <= 100),
    logical(1)
  ))
)

# Age-group counts exclude residents with unspecified age.
age_group_total <- with(
  eic_estatal,
  POB0_14 + POB15_64 + POB65_MAS
)

stopifnot(all(age_group_total <= eic_estatal$POBTOT))

# Save after all validation and conversion.
usethis::use_data(eic_estatal, overwrite = TRUE)
