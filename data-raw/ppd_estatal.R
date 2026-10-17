# Prepare ppd_estatal
#
# Source: Secretaria de Bienestar.
# Cuarto Informe Trimestral 2024.
# Table: "Poblacion Potencial, Objetivo y Atendida", printed page 30.
# Source location supplied by the package author.
# https://www.gob.mx/cms/uploads/attachment/file/969363/4toInfTrim2024.pdf
#
# Input: manual transcription of the supplied state table.
# Observation year: 2024.
# All four measures count people, not amounts or support transactions.

ppd_estatal <- read.csv(
  "data-raw/ppd_estatal.csv",
  colClasses = "character",
  fileEncoding = "UTF-8",
  check.names = FALSE
)

expected_columns <- c(
  "entidad",
  "poblacion_potencial",
  "poblacion_objetivo",
  "apoyos_economicos",
  "apoyos_en_especie"
)

stopifnot(
  identical(names(ppd_estatal), expected_columns),
  nrow(ppd_estatal) == 32L,
  !anyNA(ppd_estatal),
  all(nzchar(trimws(ppd_estatal$entidad))),
  !anyDuplicated(ppd_estatal$entidad)
)

measure_columns <- expected_columns[-1]

# Validate text before numeric conversion.
stopifnot(
  all(vapply(
    ppd_estatal[measure_columns],
    function(x) all(grepl("^[0-9]+$", x)),
    logical(1)
  ))
)

ppd_estatal[measure_columns] <- lapply(
  ppd_estatal[measure_columns],
  as.numeric
)

# National totals reported in the source.
expected_totals <- c(
  poblacion_potencial = 3615344,
  poblacion_objetivo = 2654788,
  apoyos_economicos = 1451941,
  apoyos_en_especie = 23470
)

stopifnot(
  isTRUE(all.equal(
    colSums(ppd_estatal[measure_columns]),
    expected_totals,
    tolerance = 1e-12
  ))
)

# Preserve supplied state names, row order, and numeric values,
# including zero values for in-kind support.

# Geographic codes added during package preparation.
# cve_ent: INEGI, Clasificaciones del Censo de Poblacion y
# Vivienda 2020, printed pp. 33-34.
# https://www.inegi.org.mx/contenidos/productos/prod_serv/contenidos/espanol/bvinegi/productos/nueva_estruc/702825198701.pdf
#
# iso_3166_2: checked against PCGN, Mexico: Toponymic Factfile,
# March 2025, pp. 4-6, which cites ISO 3166-2.
# https://assets.publishing.service.gov.uk/media/67eaae480678ace40a7f27a4/Mexico_Toponymic_Factfile.pdf
#
# Matching names below retain the spelling used in the PPD CSV.
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
state_index <- match(ppd_estatal$entidad, state_codes$entidad)

stopifnot(
  !anyNA(state_index),
  !anyDuplicated(state_index)
)

ppd_estatal$cve_ent <- state_codes$cve_ent[state_index]
ppd_estatal$iso_3166_2 <- state_codes$iso_3166_2[state_index]

# Place geographic identifiers immediately after the source state name.
ppd_estatal <- ppd_estatal[c(
  "entidad", "cve_ent", "iso_3166_2", measure_columns
)]

usethis::use_data(ppd_estatal, overwrite = TRUE)
