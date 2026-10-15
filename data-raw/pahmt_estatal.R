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

# Preserve supplied state names, row order, values, and monetary units.
usethis::use_data(pahmt_estatal, overwrite = TRUE)
