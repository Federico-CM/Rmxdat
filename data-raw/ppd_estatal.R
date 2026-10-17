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

# National totals reported in the source information supplied by the author.
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
usethis::use_data(ppd_estatal, overwrite = TRUE)
