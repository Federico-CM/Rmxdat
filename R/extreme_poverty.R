#' Extreme poverty by population group in Mexico, 2016–2024
#'
#' National estimates of the percentage of selected population groups in
#' extreme poverty in Mexico, using the CONEVAL methodology.
#' The data cover five biennial observations from 2016 to 2024.
#'
#' @format A data frame with 5 rows and 12 variables:
#' \describe{
#'   \item{anio}{Integer. Reference year: 2016, 2018, 2020, 2022, or
#'     2024. Values are unique and nonmissing.}
#'   \item{total}{Numeric (double). Percentage of the population in
#'     extreme poverty.}
#'   \item{hombres}{Numeric (double). Percentage of men in
#'     extreme poverty.}
#'   \item{mujeres}{Numeric (double). Percentage of women in
#'     extreme poverty.}
#'   \item{rural}{Numeric (double). Percentage of residents of localities
#'     with fewer than 2,500 inhabitants in extreme poverty.}
#'   \item{urbano}{Numeric (double). Percentage of residents of localities
#'     with 2,500 inhabitants or more in extreme poverty.}
#'   \item{edad_0_5}{Numeric (double). Percentage of children aged 0–5
#'     years, inclusive, in extreme poverty.}
#'   \item{edad_0_17}{Numeric (double). Percentage of children and
#'     adolescents aged 0–17 years, inclusive, in extreme poverty.}
#'   \item{edad_65_mas}{Numeric (double). Percentage of adults aged 65
#'     years and older in extreme poverty.}
#'   \item{indigena}{Numeric (double). Percentage of the Indigenous
#'     population, defined using INPI household and Indigenous-language
#'     criteria, in extreme poverty. See Details.}
#'   \item{afrodescendiente}{Numeric (double). Percentage of people who
#'     identify as Afromexican, Black, or Afrodescendant based on
#'     ancestry and customs in extreme poverty.
#'     Available for 2024 only; earlier observations are \code{NA}.}
#'   \item{discapacidad}{Numeric (double). Percentage of people with a
#'     disability, as defined in the source workbook, in extreme poverty.
#'     Available for 2020, 2022, and 2024; observations for 2016 and
#'     2018 are \code{NA}.}
#' }
#'
#' @details
#' The data cover Mexico at the national level (Estados Unidos Mexicanos),
#' with one reference year per row. Rows are ordered from 2024 to 2016.
#' Observations are biennial rather than annual.
#'
#' All variables except \code{anio} are percentages on a 0–100 scale;
#' for example, 5.3 means 5.3 percent. Each percentage uses the population
#' of the named group as its denominator. It does not represent that
#' group's share of all people in extreme poverty. Higher values indicate
#' greater extreme poverty.
#'
#' The indicator is "Población en situación de pobreza extrema".
#' The source estimates use the Encuesta Nacional de Ingresos y Gastos
#' de los Hogares (ENIGH) and the CONEVAL methodology.
#'
#' Extreme poverty is a component of multidimensional poverty.
#'
#' The Indigenous population follows INPI criteria. It includes all
#' members of households in which the household head, spouse, or an
#' ascendant relative reported speaking an Indigenous language, together
#' with Indigenous-language speakers outside these households.
#' Ascendant relatives include parents, stepparents, grandparents,
#' great-grandparents, great-great-grandparents, and parents-in-law.
#' This definition should not be interpreted as Indigenous
#' self-identification or ancestry alone.
#'
#' Disability follows footnote 1 of Grupos de población, Cuadro 4,
#' using the Washington Group approach described in the workbook.
#' It includes people reporting inability or great difficulty in at
#' least one listed activity. The domains cover seeing, hearing,
#' using arms or hands, walking, remembering or concentrating,
#' self-care, communication, and daily activities affected by
#' emotional or mental problems.
#'
#' Missing values indicate unavailable estimates in the selected source
#' tables. Afrodescendant population estimates are available only for
#' 2024. Disability estimates are available for 2020, 2022, and 2024.
#' Missing values are represented by \code{NA} and must not be treated
#' as zero.
#'
#' Population groups overlap. For example, children aged 0–5 years are
#' included in the group aged 0–17 years. Percentages should not be
#' summed across columns or averaged without appropriate population
#' weights to obtain a national extreme poverty rate. Differences
#' between percentages are expressed in percentage points.
#'
#' The source workbooks include precision indicators. This dataset
#' contains point estimates only, without confidence intervals or
#' precision classifications.
#'
#' INEGI does not endorse or sponsor this package.
#'
#' @section Preparation:
#' Preserved column names, row order, numeric values, and missing values.
#' Converted \code{anio} to integer and percentage variables to double.
#' Validated dimensions, column names, reference years, year uniqueness,
#' numeric text, missing-value patterns, and percentage bounds.
#' No rounding or imputation was applied.
#'
#' @section Reuse:
#' Consult the
#' \href{https://www.inegi.org.mx/inegi/terminos.html}{INEGI Terms of
#' Free Use of Information} for conditions governing reuse.
#' Retain source attribution and relevant metadata, and avoid implying
#' INEGI endorsement of the package or resulting analyses.
#'
#' @source
#' Instituto Nacional de Estadística y Geografía (INEGI).
#' Pobreza Multidimensional (PM) 2024. Selected national estimates
#' from the Grupos de población and Ámbito rural y urbano tables.
#'
#' \href{https://www.inegi.org.mx/desarrollosocial/pm/#tabulados}{
#' Pobreza Multidimensional – Tabulados}.
#'
#' INEGI's technical note attributes the 2024 estimates to INEGI
#' calculations using ENIGH 2024 and the CONEVAL methodology,
#' and the 2016–2022 estimates to CONEVAL poverty measurement.
#'
#' \href{https://www.inegi.org.mx/contenidos/desarrollosocial/pm/doc/pm_nota_tecnica_2024.pdf}{
#' INEGI: Pobreza Multidimensional 2024: Nota técnica}.
#'
#' Historical source:
#' \href{https://www.coneval.org.mx/Medicion/MP/Paginas/AE_pobreza_2022.aspx}{
#' CONEVAL: Anexo estadístico de pobreza 2022}.
#'
#' @seealso \code{\link{poverty}}
#'
#' @examples
#' head(extreme_poverty)
#'
#' # Extreme poverty percentages for men and women, ordered by year
#' extreme_poverty[
#'   order(extreme_poverty$anio),
#'   c("anio", "hombres", "mujeres")
#' ]
#'
#' # Rural–urban extreme poverty gap in percentage points
#' with(
#'   extreme_poverty,
#'   data.frame(
#'     anio = anio,
#'     brecha_rural_urbana = rural - urbano
#'   )
#' )
#'
#' # Estimates available for the Afrodescendant population
#' extreme_poverty[
#'   !is.na(extreme_poverty$afrodescendiente),
#'   c("anio", "afrodescendiente")
#' ]
#'
#' # Change from 2022 to 2024 for children aged 0–17,
#' # expressed in percentage points
#' with(
#'   extreme_poverty,
#'   edad_0_17[anio == 2024] - edad_0_17[anio == 2022]
#' )
"extreme_poverty"
