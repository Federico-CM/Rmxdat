# Prepare ppam_estatal
#
# Source: Secretaria de Bienestar.
# Cuarto Informe Trimestral 2024.
# Table: "Poblacion Potencial, Objetivo y Atendida", printed page 18.
# https://www.gob.mx/cms/uploads/attachment/file/969363/4toInfTrim2024.pdf
#
# Input: manual transcription of the state table in the source report.
# Observation year: 2024.
# All population measures count people.

ppam_estatal <- read.csv(
  "data-raw/ppam_estatal.csv",
  colClasses = "character",
  fileEncoding = "UTF-8",
  check.names = FALSE
)

expected_columns <- c(
  "entidad",
  "poblacion_potencial",
  "poblacion_objetivo",
  "poblacion_atendida"
)

stopifnot(
  identical(names(ppam_estatal), expected_columns),
  nrow(ppam_estatal) == 32L,
  !anyNA(ppam_estatal),
  all(nzchar(trimws(ppam_estatal$entidad))),
  !anyDuplicated(ppam_estatal$entidad)
)

measure_columns <- expected_columns[-1]

# Validate text before numeric conversion.
stopifnot(
  all(vapply(
    ppam_estatal[measure_columns],
    function(x) all(grepl("^[0-9]+$", x)),
    logical(1)
  ))
)

ppam_estatal[measure_columns] <- lapply(
  ppam_estatal[measure_columns],
  as.numeric
)

# Compare reconstructed totals with the published national totals.
expected_totals <- c(
  poblacion_potencial = 13332762,
  poblacion_objetivo = 13332762,
  poblacion_atendida = 12247766
)

stopifnot(
  identical(
    ppam_estatal$poblacion_potencial,
    ppam_estatal$poblacion_objetivo
  ),
  isTRUE(all.equal(
    colSums(ppam_estatal[measure_columns]),
    expected_totals,
    tolerance = 1e-12
  ))
)

# Preserve state names, row order, and population values.
# Retain served counts above target estimates.

# Geographic codes added during package preparation.
# cve_ent: INEGI, Clasificaciones del Censo de Poblacion y
# Vivienda 2020, printed pp. 33-34.
# https://www.inegi.org.mx/contenidos/productos/prod_serv/contenidos/espanol/bvinegi/productos/nueva_estruc/702825198701.pdf
#
# iso_3166_2: checked against PCGN, Mexico: Toponymic Factfile,
# March 2025, pp. 4-6, which cites ISO 3166-2.
# https://assets.publishing.service.gov.uk/media/67eaae480678ace40a7f27a4/Mexico_Toponymic_Factfile.pdf
#
# Matching names below retain the spelling used in the PPAM CSV.
state_codes <- data.frame(
  entidad = c(
    "Aguascalientes", "Baja California", "Baja California Sur",
    "Campeche", "Coahuila", "Colima", "Chiapas", "Chihuahua",
    "Ciudad de México", "Durango", "Guanajuato", "Guerrero",
    "Hidalgo", "Jalisco", "México", "Michoacán", "Morelos",
    "Nayarit", "Nuevo León", "Oaxaca", "Puebla", "Querétaro",
    "Quintana Roo", "San Luis Potosí", "Sinaloa", "Sonora",
    "Tabasco", "Tamaulipas", "Tlaxcala", "Veracruz",
    "Yucatán", "Zacatecas"
  ),
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
  !anyDuplicated(state_codes$entidad),
  !anyDuplicated(state_codes$cve_ent),
  !anyDuplicated(state_codes$iso_3166_2)
)

# Match by name, preserving the source row order.
state_index <- match(ppam_estatal$entidad, state_codes$entidad)

stopifnot(
  !anyNA(state_index),
  !anyDuplicated(state_index)
)

ppam_estatal$cve_ent <- state_codes$cve_ent[state_index]
ppam_estatal$iso_3166_2 <- state_codes$iso_3166_2[state_index]

# Place geographic identifiers immediately after the source state name.
ppam_estatal <- ppam_estatal[c(
  "entidad", "cve_ent", "iso_3166_2", measure_columns
)]

usethis::use_data(ppam_estatal, overwrite = TRUE)
