# Masterclass UCM sobre Sistemas de Recomendación

## Bienvenid@!

Bienvenid@ a esta masterclass sobre Sistemas de Recomendación. 

Tras esta clase aprenderás...

- Qué es un Sistema de Recomendación y cómo funciona
- Qué tipos de Sistemas de Recomendación existen
- En qué consiste el Filtro Colaborativo y los métodos basados en contenido
- Cómo funciona Netflix
- Cómo construir un sistema de recomendación en R, desde el algoritmo hasta la app final!

## Para esta clase necesitarás...

- Instalar algunas librerías de R, como tidyverse, shiny o recommenderlab.

```{r pkg-list}
#| eval: false
pkg_list <- c(
  "tidyverse", "shiny", "recommenderlab", "reactable", "rmarkdown", "glue", "bslib"
  )
install.packages(pkg_list)
```

- La última versión de R (R 3.3.0+) y RStudio(2022.07.2+576). 
[Sigue los pasos aquí](https://posit.co/download/rstudio-desktop/)


## Programación

| [Parte 1 - Introducción a los Sistemas de Recomendación](material/parte1-sistemas_de_recomendacion.qmd) |
| [Parte 2 - {recommenderlab}, la librería de R de Algoritmos de Recomendación](material/parte2-recommenderlab.qmd)|
| [Parte 3 - Construyendo Netflix en R con Shiny](material/parte3-shiny_app.qmd)                      |