#' PPD population estimates and beneficiaries by state, 2024
#'
#' State-level counts of the potential and target populations and
#' beneficiaries receiving monetary or in-kind support from Mexico's
#' Programa Pensión para el Bienestar de las Personas con Discapacidad
#' Permanente for 2024.
#'
#' @format A data frame with 32 rows and 5 variables:
#' \describe{
#'   \item{entidad}{Character. Name of the Mexican state.}
#'   \item{poblacion_potencial}{Numeric. Preliminary estimated potential
#'     population of the program for 2024, expressed as a number of people.}
#'   \item{poblacion_objetivo}{Numeric. Preliminary estimated target
#'     population of the program for 2024, expressed as a number of people.}
#'   \item{apoyos_economicos}{Numeric. Cumulative number of unique
#'     beneficiaries who received monetary support during
#'     January–December 2024, as reported on December 31, 2024.
#'     Includes beneficiaries covered by agreements to universalize
#'     the pension.}
#'   \item{apoyos_en_especie}{Numeric. Number of beneficiaries aged
#'     0–17 years who received in-kind support for rehabilitation
#'     services during January–December 2024, as reported on
#'     December 31, 2024.}
#' }
#'
#' @details
#' The data cover the 32 Mexican states. The observation year is 2024
#' and is recorded here rather than in a separate dataset column.
#'
#' The program aims to improve the monetary income of households of
#' Mexican people with permanent disabilities. Its target population
#' comprises Mexican citizens by birth or naturalization with permanent
#' disabilities who currently reside in Mexico and meet one of the
#' following conditions:
#'
#' - Are aged 0–29 years.
#' - Are aged 30–64 years and live in Indigenous or Afro-Mexican
#'   municipalities or localities, or in municipalities or localities
#'   with high or very high marginalization.
#' - Are aged 30–64 years and reside in a state whose government has
#'   signed an agreement to universalize the pension for people with
#'   permanent disabilities.
#'
#' Monetary support consists of pension payments. In-kind support
#' consists of vouchers for rehabilitation services for beneficiaries
#' aged 0–17 years.
#'
#' All four numeric variables count people. The support variables do
#' not measure monetary amounts, payments, vouchers, or rehabilitation
#' sessions. Monetary-support and in-kind-support counts are not added,
#' to avoid double-counting the served population.
#'
#' Preparation preserved supplied state names, row order, and numeric
#' values, including zero values for in-kind support.
#'
#' This is an independent project with no affiliation with the
#' United Nations or the Mexican government.
#'
#' @section Reuse:
#' The source data are reproduced from an official Secretaría de
#' Bienestar administrative report, relying on Article 14(VIII)
#' of Mexico's Ley Federal del Derecho de Autor. Rmxdat claims no
#' exclusive rights over these source data. See the installed
#' COPYRIGHTS file for attribution, the legal reference, and
#' preparation details.
#'
#' @source
#' Secretaría de Bienestar.
#' *Cuarto Informe Trimestral 2024: Programas de Subsidios del
#' Ramo Administrativo 20-Bienestar*.
#' Section "Programa Pensión para el Bienestar de las Personas con
#' Discapacidad Permanente", table "Población Potencial, Objetivo y
#' Atendida", printed p. 30, including table notes; population
#' definition on printed p. 29 and descriptions of support on
#' printed p. 31. The table identifies the Unidad para la Atención
#' de Grupos Prioritarios as its source.
#'
#' The source CSV is a manual transcription of the report table.
#'
#' <https://www.gob.mx/cms/uploads/attachment/file/969363/4toInfTrim2024.pdf>
#'
#' @examples
#' head(ppd_estatal)
#'
#' # Reconstruct PPD; the national number of monetary-support beneficiaries
#' sum(ppd_estatal$apoyos_economicos)
#'
#' # Reconstruct the national number of in-kind-support beneficiaries
#' sum(ppd_estatal$apoyos_en_especie)
"ppd_estatal"
