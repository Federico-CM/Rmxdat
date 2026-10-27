# Prepare pahmt_estatal
#
# Source: Auditoría Superior de la Federación (ASF).
# Cuenta Pública 2024, audit no. 295, page 17.
# https://www.asf.gob.mx/Trans/Informes/IR2024b/Documentos/Auditorias/2024_0295_a.pdf
#
# Input: manual transcription of the published state table.
# Observation year: 2024.
# Amounts are in thousands of Mexican pesos.

pahmt_estatal <- read.csv(
  "data-raw/pahmt_estatal.csv",
  colClasses = "character",
  fileEncoding = "UTF-8",
  check.names = FALSE
)

expected_columns <- c(
  "entidad",
  "beneficiarios_A",
  "beneficiarios_B",
  "importe_A",
  "importe_B"
)

stopifnot(
  identical(names(pahmt_estatal), expected_columns),
  nrow(pahmt_estatal) == 32L,
  !anyNA(pahmt_estatal),
  all(nzchar(trimws(pahmt_estatal$entidad))),
  !anyDuplicated(pahmt_estatal$entidad)
)

count_columns <- c("beneficiarios_A", "beneficiarios_B")
amount_columns <- c("importe_A", "importe_B")

# Validate text before numeric conversion.
stopifnot(
  all(vapply(
    pahmt_estatal[count_columns],
    function(x) all(grepl("^[0-9]+$", x)),
    logical(1)
  )),
  all(vapply(
    pahmt_estatal[amount_columns],
    function(x) all(grepl("^[0-9]+(\\.[0-9]+)?$", x)),
    logical(1)
  ))
)

measure_columns <- c(count_columns, amount_columns)

pahmt_estatal[measure_columns] <- lapply(
  pahmt_estatal[measure_columns],
  as.numeric
)

# Compare reconstructed totals with the published national totals.
expected_totals <- c(
  beneficiarios_A = 221123,
  beneficiarios_B = 49133,
  importe_A = 1823984.8,
  importe_B = 552222.5
)

stopifnot(
  isTRUE(all.equal(
    colSums(pahmt_estatal[measure_columns]),
    expected_totals,
    tolerance = 1e-12
  ))
)

# Add geographic identifiers using source state names.
# References:
# INEGI, Clasificaciones del Censo de Población y Vivienda 2020,
# printed pages 33–34:
# https://www.inegi.org.mx/contenidos/productos/prod_serv/contenidos/espanol/bvinegi/productos/nueva_estruc/702825198701.pdf
#
# UK Permanent Committee on Geographical Names,
# Mexico: Toponymic Factfile, March 2025, pages 4–6:
# https://assets.publishing.service.gov.uk/media/67eaae480678ace40a7f27a4/Mexico_Toponymic_Factfile.pdf
#
# Estado de México corresponds to México; Coahuila, Michoacán,
# and Veracruz correspond to Coahuila de Zaragoza, Michoacán
# de Ocampo, and Veracruz de Ignacio de la Llave.

state_codes <- data.frame(
  entidad = c(
    "Aguascalientes", "Baja California", "Baja California Sur",
    "Campeche", "Coahuila", "Colima", "Chiapas", "Chihuahua",
    "Ciudad de México", "Durango", "Guanajuato", "Guerrero",
    "Hidalgo", "Jalisco", "Estado de México", "Michoacán",
    "Morelos", "Nayarit", "Nuevo León", "Oaxaca", "Puebla",
    "Querétaro", "Quintana Roo", "San Luis Potosí", "Sinaloa",
    "Sonora", "Tabasco", "Tamaulipas", "Tlaxcala", "Veracruz",
    "Yucatán", "Zacatecas"
  ),
  cve_ent = sprintf("%02d", 1:32),
  iso_3166_2 = c(
    "MX-AGU", "MX-BCN", "MX-BCS", "MX-CAM", "MX-COA", "MX-COL",
    "MX-CHP", "MX-CHH", "MX-CMX", "MX-DUR", "MX-GUA", "MX-GRO",
    "MX-HID", "MX-JAL", "MX-MEX", "MX-MIC", "MX-MOR", "MX-NAY",
    "MX-NLE", "MX-OAX", "MX-PUE", "MX-QUE", "MX-ROO", "MX-SLP",
    "MX-SIN", "MX-SON", "MX-TAB", "MX-TAM", "MX-TLA", "MX-VER",
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

state_index <- match(pahmt_estatal$entidad, state_codes$entidad)

stopifnot(
  !anyNA(state_index),
  !anyDuplicated(state_index)
)

pahmt_estatal$cve_ent <- state_codes$cve_ent[state_index]
pahmt_estatal$iso_3166_2 <- state_codes$iso_3166_2[state_index]

pahmt_estatal <- pahmt_estatal[c(
  "entidad",
  "cve_ent",
  "iso_3166_2",
  "beneficiarios_A",
  "beneficiarios_B",
  "importe_A",
  "importe_B"
)]

# Preserve state names, row order, values, and monetary units.
usethis::use_data(pahmt_estatal, overwrite = TRUE)
