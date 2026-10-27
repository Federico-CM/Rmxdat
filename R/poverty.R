#' Poverty by population group in Mexico, 2016–2024
#'
#' National estimates of the percentage of selected population groups in
#' multidimensional poverty in Mexico, using the CONEVAL methodology.
#' The data cover five biennial observations from 2016 to 2024.
#'
#' @format A data frame with 5 rows and 12 variables:
#' \describe{
#'   \item{anio}{Integer. Reference year: 2016, 2018, 2020, 2022, or
#'     2024. Values are unique and nonmissing.}
#'   \item{total}{Numeric (double). Percentage of people in
#'     multidimensional poverty (ODS 1n.1.1).}
#'   \item{hombres}{Numeric (double). Percentage of men in
#'     multidimensional poverty (ODS 1n.1.1).}
#'   \item{mujeres}{Numeric (double). Percentage of women in
#'     multidimensional poverty (ODS 1n.1.1).}
#'   \item{rural}{Numeric (double). Percentage of residents of localities
#'     with fewer than 2,500 inhabitants in multidimensional poverty
#'     (ODS 1n.1.1).}
#'   \item{urbano}{Numeric (double). Percentage of residents of localities
#'     with 2,500 inhabitants or more in multidimensional poverty.}
#'   \item{edad_0_5}{Numeric (double). Percentage of children aged 0–5
#'     years, inclusive, in multidimensional poverty (ODS 1n.1.1).}
#'   \item{edad_0_17}{Numeric (double). Percentage of children and
#'     adolescents aged 0–17 years, inclusive, in multidimensional
#'     poverty (ODS 1n.1.1).}
#'   \item{edad_65_mas}{Numeric (double). Percentage of adults aged 65
#'     years and older in multidimensional poverty (ODS 1n.1.1).}
#'   \item{indigena}{Numeric (double). Percentage of the Indigenous
#'     population, defined using INPI household and Indigenous-language
#'     criteria, in multidimensional poverty (ODS 1n.1.1).
#'     See Details.}
#'   \item{afrodescendiente}{Numeric (double). Percentage of people who
#'     identify as Afromexican, Black, or Afrodescendant based on
#'     ancestry and customs in multidimensional poverty (ODS 1n.1.1).
#'     Available for 2024 only; earlier observations are \code{NA}.}
#'   \item{discapacidad}{Numeric (double). Percentage of people with a
#'     disability, as defined in the source workbook, in multidimensional
#'     poverty (ODS 1n.1.1). Available for 2020, 2022, and 2024;
#'     observations for 2016 and 2018 are \code{NA}.}
#' }
#'
#' @details
#' The data cover Mexico at the national level (Estados Unidos Mexicanos),
#' with one reference year per row. Rows are ordered from 2024 to 2016.
#' Observations are biennial rather than annual.
#'
#' All variables except \code{anio} are percentages on a 0–100 scale.
#' Each percentage uses the population
#' of the named group as its denominator. It does not represent that
#' group's share of all people in poverty. Higher values indicate
#' greater poverty.
#'
#' The indicator is "Población en situación de pobreza", which includes
#' both moderate and extreme poverty. The source estimates use the
#' Encuesta Nacional de Ingresos y Gastos de los Hogares (ENIGH) and
#' the CONEVAL methodology.
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
#' 2024. Disability estimates begin in 2020, when ENIGH introduced the
#' disability-identification question. Missing values are represented
#' by \code{NA} and must not be treated as zero.
#'
#' Population groups overlap. For example, children aged 0–5 years are
#' included in the group aged 0–17 years. Percentages should not be
#' summed across columns or averaged without appropriate population
#' weights to obtain a national poverty rate. Differences between
#' percentages are expressed in percentage points.
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
#' The source information is subject to the
#' \href{https://www.inegi.org.mx/inegi/terminos.html}{INEGI Terms of
#' Free Use of Information}. These terms permit copying, redistribution,
#' adaptation, extraction, and commercial use, subject to the stated
#' conditions, including attribution to INEGI, preservation of metadata
#' when distributing copies, and avoidance of implied INEGI endorsement.
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
#' @examples
#' head(poverty)
#'
#' # Poverty percentages for men and women, ordered by year
#' poverty[
#'   order(poverty$anio),
#'   c("anio", "hombres", "mujeres")
#' ]
#'
#' # Rural–urban poverty gap in percentage points
#' with(
#'   poverty,
#'   data.frame(
#'     anio = anio,
#'     brecha_rural_urbana = rural - urbano
#'   )
#' )
#'
#' # Estimates available for the Afrodescendant population
#' poverty[
#'   !is.na(poverty$afrodescendiente),
#'   c("anio", "afrodescendiente")
#' ]
#'
#' # Change from 2022 to 2024 for children aged 0–17,
#' # expressed in percentage points
#' with(
#'   poverty,
#'   edad_0_17[anio == 2024] - edad_0_17[anio == 2022]
#' )
"poverty"
