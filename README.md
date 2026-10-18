# Rmxdat

Rmxdat provides documented datasets about Mexico to support analysis
of sustainable development, social conditions, and state-level indicators.

The initial focus is on data relevant to monitoring the United Nations
Sustainable Development Cooperation Framework for Mexico, 2026–2031.
The relationship between each dataset and specific framework indicators
requires separate verification.

Rmxdat is an independent project with no affiliation with the United
Nations or the Mexican government.

## Development status

The package is in early development and currently contains four datasets.
The package has been checked locally. Dataset names, structure, and
documentation may change.

## Available data

`bienestar_beneficiarios` contains state-level information on unique
beneficiaries and reported interventions from the Secretaría de Bienestar's
Padrón Único de Beneficiarios.

- 748 rows and 14 variables.
- Quarterly observations from 2019T1 through 2024T3.
- Coverage of Mexico's 32 states.
- Additional records coded `99` (`NO ESPECIFICADO`) during 2019–2021.

The source includes a fractional `intervenciones` value for Guerrero
in 2019T4. This value is preserved and documented.

`pahmt_estatal` contains state-level beneficiary counts and financial
assistance for the Programa de Apoyo para el Bienestar de las Niñas
y Niños, Hijos de Madres Trabajadoras.

- 32 rows and 5 variables.
- Annual data for 2024 covering Mexico's 32 states.
- Separate beneficiary counts and amounts for modalities A and B.
- Amounts expressed in thousands of Mexican pesos.

The beneficiary columns can be used to calculate PAHMT, a component of
framework indicator 4.a. The national total is 270,256 beneficiaries.
This program total does not establish an unduplicated count across
multiple welfare programs.

`ppam_estatal` contains state-level potential, target, and served
population counts for the Programa Pensión para el Bienestar de las
Personas Adultas Mayores.

- 32 rows and 6 variables.
- Annual data for 2024 covering Mexico's 32 states.
- Potential and target populations are preliminary estimates.
- Served population counts unique beneficiaries with pension payments
  during January–December 2024.
- Includes INEGI state codes (`cve_ent`) and ISO 3166-2 subdivision
  codes (`iso_3166_2`), added during preparation.
- Preserves state names as published in the source.

Summing the served population across states gives a national PPAM count
of 12,247,766 beneficiaries. Served counts exceed target estimates in
Michoacán and Zacatecas; these source values are preserved.

`ppd_estatal` contains state-level population estimates and beneficiary
counts for the Programa Pensión para el Bienestar de las Personas
con Discapacidad Permanente.

- 32 rows and 7 variables.
- Annual data for 2024 covering Mexico's 32 states.
- Preliminary potential and target population estimates.
- Separate counts of monetary-support and in-kind-support beneficiaries.
- All numeric variables count people.
- Includes INEGI state codes (`cve_ent`) and ISO 3166-2 subdivision
  codes (`iso_3166_2`), added during preparation.
- Preserves state names as published in the source.

National totals are 1,451,941 monetary-support beneficiaries (PPD) and 23,470
in-kind-support beneficiaries. These counts must not be added together
to calculate the served population because doing so would double-count
beneficiaries. The source identifies the information as preliminary.

## Usage

After installing the package locally:

```r
library(Rmxdat)

head(bienestar_beneficiarios)

subset(
  bienestar_beneficiarios,
  CVEENT == "12" & periodo_cve == "2019T4"
)

head(pahmt_estatal)

# National beneficiary count: PAHMT
with(pahmt_estatal, sum(beneficiarios_A + beneficiarios_B))

head(ppam_estatal)

# National beneficiary count: PPAM
sum(ppam_estatal$poblacion_atendida)

head(ppd_estatal)

# National monetary-support beneficiary count: PPD
sum(ppd_estatal$apoyos_economicos)

# National in-kind-support beneficiary count
sum(ppd_estatal$apoyos_en_especie)

```

Open the dataset help pages for variable definitions, source information,
preparation details, and known limitations:

```r
?bienestar_beneficiarios
?pahmt_estatal
?ppam_estatal
?ppd_estatal
```

## Sources

The first dataset comes from the Secretaría de Bienestar:

[Padrón único de beneficiarios Bienestar](https://www.datos.gob.mx/dataset/padron_unico_beneficiarios_bienestar)

The source CSV was downloaded on 2026-10-12. Download and source metadata
dates are distinct from the observation periods covered by the data.

`pahmt_estatal` was manually transcribed from page 17 of the Auditoría
Superior de la Federación's Cuenta Pública 2024 audit no. 295:

[ASF audit report: Programa de Apoyo para el Bienestar de las Niñas y Niños, Hijos de Madres Trabajadoras](https://www.asf.gob.mx/Trans/Informes/IR2024b/Documentos/Auditorias/2024_0295_a.pdf)

`ppam_estatal` and `ppd_estatal` were manually transcribed from the state
tables on printed pages 18 and 30, respectively, of the Secretaría de
Bienestar's Cuarto Informe Trimestral 2024:

[Cuarto Informe Trimestral 2024: Programas de Subsidios del Ramo Administrativo 20-Bienestar](https://www.gob.mx/cms/uploads/attachment/file/969363/4toInfTrim2024.pdf)

Geographic codes added to `ppam_estatal` and `ppd_estatal` follow INEGI's
[Clasificaciones del Censo de Población y Vivienda 2020](https://www.inegi.org.mx/contenidos/productos/prod_serv/contenidos/espanol/bvinegi/productos/nueva_estruc/702825198701.pdf),
printed pages 33–34. ISO 3166-2 codes were checked against the UK
Permanent Committee on Geographical Names'
[Mexico: Toponymic Factfile](https://assets.publishing.service.gov.uk/media/67eaae480678ace40a7f27a4/Mexico_Toponymic_Factfile.pdf),
March 2025, pages 4–6, which cites ISO's Mexico entry.

## Licensing

Original package code and documentation are licensed under the MIT license.

The bundled `bienestar_beneficiarios` dataset retains its Creative Commons
Attribution 4.0 International (CC BY 4.0) license. The package's MIT license
does not replace the dataset license.

The `pahmt_estatal`, `ppam_estatal`, and `ppd_estatal` source data are
reproduced from official administrative reports. PAHMT comes from the ASF;
PPAM and PPD come from the Secretaría de Bienestar. Reuse relies on
Article 14(VIII) of Mexico's Ley Federal del Derecho de Autor.
Rmxdat claims no exclusive rights over these source data.

See the dataset help pages and the installed `COPYRIGHTS` notice for
attribution, reuse information, and preparation details.
