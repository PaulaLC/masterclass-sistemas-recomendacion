# Librerías
library(shiny)
library(glue)
library(bslib)
library(recommenderlab)
library(dplyr)

# Fuentes
source("R/utils.R")

# Datos
#m <- as.matrix(df)
#as(m, 'realRatingMatrix') # getRatingMatrix(m_aux)

data("MovieLense")
MovieLenseSmall <- MovieLense[1:100, colCounts(MovieLense) > 250]
df_peliculas <- read.csv("peliculas.csv") # csv con los títulos y url de las caráctulas de las películas
train_data <- MovieLenseSmall[1:75, ]
user_data <- MovieLenseSmall[76]


# Dataframes de recomendación
df_ubcf <- recomendar_pelicula(train_data, user_data, "UBCF", list(nn = 3), NULL)
df_ibcf <- recomendar_pelicula(train_data, user_data, "IBCF", list(k = 100), 
                               df_ubcf$item)
df_popular <- recomendar_pelicula(train_data, user_data, "POPULAR", NULL, 
                                  c(df_ubcf$item, df_ibcf$item))
df_random <- recomendar_pelicula(train_data, user_data, "RANDOM",  NULL, 
                                 c(df_ubcf$item, df_ibcf$item, df_popular$item))



ui <- shiny::fluidPage(
  
  includeCSS("custom.css"),
  
  theme = bslib::bs_theme(
    version = 5, # Boostrap 5
    bg = "#000000", # Background oscuro
    fg = "#FFFFFF",
    primary = "#e50914", # Rojo de Netflix como color principal
    base_font = "'Helvetica Neue', 'Segoe UI', Roboto, Ubuntu, sans-serif" # Fuente de Netflix
    ), 
  
  navbarPage("NETFLIX",
             tabPanel("Home"),
             tabPanel("Series"),
             tabPanel("Películas")
  ),
  
  shiny::div(class="container px-4 px-lg-5",
    shiny::h2("Porque a otros como tú le han gustado"),
    shiny::div(class="container-fluid py-2 overflow-scroll",
      shiny::div(class="d-flex flex-row flex-nowrap", 
        generar_reco_cards(df_ubcf, df_peliculas)
      )
    )
  ),
  
  shiny::div(class="container px-4 px-lg-5",
    shiny::h2("Porque has visto películas parecidas"),
    shiny::div(class="container-fluid py-2 overflow-scroll",
      shiny::div(class="d-flex flex-row flex-nowrap", 
        generar_reco_cards(df_ibcf, df_peliculas)
      )
    )
  ),
  
  shiny::div(class="container px-4 px-lg-5",
    shiny::h2("Las películas más populares"),
    shiny::div(class="container-fluid py-2 overflow-scroll",
      shiny::div(class="d-flex flex-row flex-nowrap", 
        generar_reco_cards(df_popular, df_peliculas)
      )
   )
  ),
  
  shiny::div(class="container px-4 px-lg-5",
    shiny::h2("Descubre otras películas"),
    shiny::div(class="container-fluid py-2 overflow-scroll",
      shiny::div(class="d-flex flex-row flex-nowrap", 
        generar_reco_cards(df_random, df_peliculas)
        )
    )
  )
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)
