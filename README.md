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

The package is in early development. It currently contains one dataset
and has been installed and checked locally. Dataset names, structure,
and documentation may change.

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

## Usage

After installing the package locally:

```r
library(Rmxdat)

head(bienestar_beneficiarios)

subset(
  bienestar_beneficiarios,
  CVEENT == "12" & periodo_cve == "2019T4"
)
```

Open the dataset help page for variable definitions, source information,
preparation details, and known limitations:

```r
?bienestar_beneficiarios
```

## Source

The first dataset comes from the Secretaría de Bienestar:

[Padrón único de beneficiarios Bienestar](https://www.datos.gob.mx/dataset/padron_unico_beneficiarios_bienestar)

The source CSV was downloaded on 2026-10-12. Download and source metadata
dates are distinct from the observation periods covered by the data.

## Licensing

Original package code and documentation are licensed under the MIT license.

The bundled `bienestar_beneficiarios` dataset retains its Creative Commons
Attribution 4.0 International (CC BY 4.0) license. The package's MIT license
does not replace the dataset license.

See the dataset help page and the installed `COPYRIGHTS` notice for
attribution and preparation details.
