# Selected state-level population characteristics, EIC 2025.
# Source: INEGI, Encuesta Intercensal 2025.
# Principales resultados por localidad de 50 000 y más habitantes.
# https://www.inegi.org.mx/programas/eic/2025/#datos_abiertos
# Download date: 2026-10-19.
#
# Input: extract containing 32 state records and 10 source variables.
# Convert column names to lowercase and add ISO 3166-2 codes.
# Preserve state names, INEGI codes, row order, and numeric values.

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

# Standardize column names after validating the source fields.
names(eic_estatal) <- tolower(names(eic_estatal))

# Reuse the geographic mapping established for the other state datasets.
# ISO codes: PCGN, Mexico: Toponymic Factfile, March 2025, pp. 4-6,
# which cites ISO 3166-2.
# https://assets.publishing.service.gov.uk/media/67eaae480678ace40a7f27a4/Mexico_Toponymic_Factfile.pdf
state_codes <- data.frame(
  cve_ent = sprintf("%02d", 1:32),
  iso_3166_2 = c(
    "MX-AGU", "MX-BCN", "MX-BCS", "MX-CAM", "MX-COA",
    "MX-COL", "MX-CHP", "MX-CHH", "MX-CMX", "MX-DUR",
    "MX-GUA", "MX-GRO", "MX-HID", "MX-JAL", "MX-MEX",
    "MX-MIC", "MX-MOR", "MX-NAY", "MX-NLE", "MX-OAX",
    "MX-PUE", "MX-QUE", "MX-ROO", "MX-SLP", "MX-SIN",
    "MX-SON", "MX-TAB", "MX-TAM", "MX-TLA", "MX-VER",
    "MX-YUC", "MX-ZAC"
  ),
  stringsAsFactors = FALSE
)

stopifnot(
  nrow(state_codes) == 32L,
  !anyNA(state_codes),
  !anyDuplicated(state_codes$cve_ent),
  !anyDuplicated(state_codes$iso_3166_2)
)

# Match by INEGI identifier, preserving source row order.
state_index <- match(eic_estatal$cve_ent, state_codes$cve_ent)

stopifnot(
  !anyNA(state_index),
  !anyDuplicated(state_index)
)

eic_estatal$iso_3166_2 <- state_codes$iso_3166_2[state_index]

# Place ISO codes immediately after the existing INEGI identifier.
eic_estatal <- eic_estatal[c(
  "nom_ent", "cve_ent", "iso_3166_2",
  tolower(expected_names[-c(1, 2)])
)]

stopifnot(
  identical(dim(eic_estatal), c(32L, 11L)),
  identical(names(eic_estatal), c(
    "nom_ent", "cve_ent", "iso_3166_2", "pobtot",
    "mediana_pobtot", "pob0_14", "pob15_64", "pob65_mas",
    "pcn_pob_ind", "pcn_p3ym_hli", "pcn_pob_afro"
  )),
  is.character(eic_estatal$cve_ent),
  identical(sort(eic_estatal$cve_ent), sprintf("%02d", 1:32)),
  !anyNA(eic_estatal$iso_3166_2),
  !anyDuplicated(eic_estatal$iso_3166_2)
)

# Save after all validation and conversion.
usethis::use_data(eic_estatal, overwrite = TRUE)
