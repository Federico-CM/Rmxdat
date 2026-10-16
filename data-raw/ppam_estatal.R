# Prepare ppam_estatal
#
# Source: Secretaria de Bienestar.
# Cuarto Informe Trimestral 2024.
# Table: "Poblacion Potencial, Objetivo y Atendida", printed page 18.
# https://www.gob.mx/cms/uploads/attachment/file/969363/4toInfTrim2024.pdf
#
# Input: manual transcription of the supplied state table.
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

# Preserve supplied state names, row order, and population values.
# Retain served counts above target estimates.
usethis::use_data(ppam_estatal, overwrite = TRUE)
