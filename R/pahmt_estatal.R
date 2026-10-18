#' PAHMT beneficiaries and financial assistance by state, 2024
#'
#' State-level beneficiary counts and financial assistance provided through
#' Mexico's Programa de Apoyo para el Bienestar de las Niñas y Niños,
#' Hijos de Madres Trabajadoras during 2024.
#'
#' @format A data frame with 32 rows and 7 variables:
#' \describe{
#'   \item{entidad}{Character. Name of the beneficiary's state of residence.}
#'   \item{cve_ent}{Character. Two-digit INEGI state code, preserving
#'     leading zeros.}
#'   \item{iso_3166_2}{Character. ISO 3166-2 subdivision code,
#'     including the MX prefix.}
#'   \item{beneficiarios_A}{Numeric. Number of beneficiaries in modality A.}
#'   \item{beneficiarios_B}{Numeric. Number of beneficiaries in modality B.}
#'   \item{importe_A}{Numeric. Amount granted to beneficiaries in modality A,
#'     in thousands of Mexican pesos.}
#'   \item{importe_B}{Numeric. Amount granted to beneficiaries in modality B,
#'     in thousands of Mexican pesos.}
#' }
#'
#' @details
#' The data cover the 32 Mexican states for the observation year 2024.
#' The year is recorded here rather than in a separate dataset column.
#'
#' The program provides assistance through two modalities:
#' \itemize{
#'   \item Modality A supports children younger than four years, or younger
#'     than six years with a disability, in situations of vulnerability
#'     due to the temporary or permanent absence of one or both parents.
#'   \item Modality B supports children, adolescents, and young adults
#'     up to 23 years of age whose mothers have died.
#' }
#'
#' These data can be used to calculate PAHMT, the number of people supported
#' by this program, for work on indicator 4.a of the Marco de Cooperación
#' de las Naciones Unidas para el Desarrollo Sostenible de México
#' 2026–2031. PAHMT is a beneficiary count, not a monetary amount.
#' Summing the two beneficiary columns across states gives 270,256:
#' 221,123 in modality A and 49,133 in modality B.
#'
#' Monetary values are expressed in thousands of Mexican pesos.
#' Multiply by 1,000 to express the amounts in pesos.
#'
#' This is an independent project with no affiliation with the
#' United Nations or the Mexican government.
#'
#' Geographic identifiers were added by matching state names, preserving
#' source state names, row order, beneficiary counts, financial amounts,
#' and monetary units. The source name Estado de México corresponds to
#' México; Coahuila, Michoacán, and Veracruz correspond to Coahuila de
#' Zaragoza, Michoacán de Ocampo, and Veracruz de Ignacio de la Llave.
#'
#' @section Reuse:
#' The source data are reproduced from an official ASF administrative
#' report, relying on Article 14(VIII) of Mexico's Ley Federal del
#' Derecho de Autor. Rmxdat claims no exclusive rights over these
#' source data. See the installed COPYRIGHTS file for attribution,
#' the legal reference, and preparation details.
#'
#' @source
#' Auditoría Superior de la Federación (ASF).
#' Cuenta Pública 2024. Secretaría de Bienestar.
#' *Programa de Apoyo para el Bienestar de las Niñas y Niños,
#' Hijos de Madres Trabajadoras*.
#' Auditoría de Cumplimiento 2024-0-20100-19-0295-2025,
#' audit no. 295, p. 17.
#'
#' <https://www.asf.gob.mx/Trans/Informes/IR2024b/Documentos/Auditorias/2024_0295_a.pdf>
#'
#' Geographic code references:
#'
#' INEGI. *Clasificaciones del Censo de Población y Vivienda 2020*,
#' printed pp. 33–34.
#'
#' <https://www.inegi.org.mx/contenidos/productos/prod_serv/contenidos/espanol/bvinegi/productos/nueva_estruc/702825198701.pdf>
#'
#' UK Permanent Committee on Geographical Names.
#' *Mexico: Toponymic Factfile*, March 2025, pp. 4–6.
#'
#' <https://assets.publishing.service.gov.uk/media/67eaae480678ace40a7f27a4/Mexico_Toponymic_Factfile.pdf>
#'
#' @examples
#' head(pahmt_estatal)
#'
#' # National beneficiary count: PAHMT
#' with(pahmt_estatal, sum(beneficiarios_A + beneficiarios_B))
#'
#' # National amounts, in thousands of Mexican pesos
#' colSums(pahmt_estatal[c("importe_A", "importe_B")])
"pahmt_estatal"
