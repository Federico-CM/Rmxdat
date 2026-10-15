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

The package is in early development and currently contains two datasets.
The first dataset has been installed and checked locally; checks for the
newly added dataset are pending. Dataset names, structure, and documentation
may change.

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
```

Open the dataset help pages for variable definitions, source information,
preparation details, and known limitations:

```r
?bienestar_beneficiarios
?pahmt_estatal
```

## Sources

The first dataset comes from the Secretaría de Bienestar:

[Padrón único de beneficiarios Bienestar](https://www.datos.gob.mx/dataset/padron_unico_beneficiarios_bienestar)

The source CSV was downloaded on 2026-10-12. Download and source metadata
dates are distinct from the observation periods covered by the data.

`pahmt_estatal` was manually transcribed from page 17 of the Auditoría
Superior de la Federación's Cuenta Pública 2024 audit no. 295:

[ASF audit report: Programa de Apoyo para el Bienestar de las Niñas y Niños, Hijos de Madres Trabajadoras](https://www.asf.gob.mx/Trans/Informes/IR2024b/Documentos/Auditorias/2024_0295_a.pdf)

## Licensing

Original package code and documentation are licensed under the MIT license.

The bundled `bienestar_beneficiarios` dataset retains its Creative Commons
Attribution 4.0 International (CC BY 4.0) license. The package's MIT license
does not replace the dataset license.

The `pahmt_estatal` source data are reproduced from an official ASF
administrative report, relying on Article 14(VIII) of Mexico's Ley Federal
del Derecho de Autor. Rmxdat claims no exclusive rights over these
source data.

See the dataset help pages and the installed `COPYRIGHTS` notice for
attribution, reuse information, and preparation details.
