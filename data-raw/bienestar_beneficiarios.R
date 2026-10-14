# Bienestar dataset
# Downloaded: 2026-10-12
# Source: Secretaría de Bienestar, datos.gob.mx
# License: CC BY 4.0, as displayed on the dataset page.
# Dataset help includes variable descriptions based on that dictionary.

csv_path <- "data-raw/padron_unico_bienestar.csv"

bienestar_raw <- read.csv(
  csv_path,
  colClasses = "character",
  stringsAsFactors = FALSE,
  check.names = FALSE
)

count_cols <- c(
  "beneficiarios", "intervenciones",
  "dependencias", "padrones", "programas"
)

# Check numeric text before conversion, allowing fractional values.
stopifnot(
  all(vapply(
    bienestar_raw[count_cols],
    function(x) all(!is.na(x) & grepl("^[0-9]+(\\.[0-9]+)?$", x)),
    logical(1)
  )),
  all(!is.na(bienestar_raw$anio) &
        grepl("^[0-9]{4}$", bienestar_raw$anio)),
  !anyDuplicated(bienestar_raw[c("CVEENT", "periodo_cve")])
)

bienestar_beneficiarios <- bienestar_raw

bienestar_beneficiarios[count_cols] <- lapply(
  bienestar_raw[count_cols],
  as.numeric
)

bienestar_beneficiarios$anio <- as.integer(bienestar_raw$anio)

bienestar_beneficiarios$fecha <- as.Date(
  bienestar_raw$fecha,
  format = "%Y-%m-%d"
)

# Confirm dates converted without changing the source date strings.
stopifnot(
  !anyNA(bienestar_beneficiarios$fecha),
  all(
    format(bienestar_beneficiarios$fecha, "%Y-%m-%d") ==
      bienestar_raw$fecha
  )
)

# Preserve all rows, column names, and geographic codes.
# Code "99" means "NO ESPECIFICADO".
# Preserve the fractional intervenciones value for Guerrero, 2019T4.
usethis::use_data(bienestar_beneficiarios, overwrite = TRUE)
