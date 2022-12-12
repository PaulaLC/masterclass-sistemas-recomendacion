#' Card de Boostrap que contiene el título de una película, la carátula y el 
#' rating normalizado
#'
#' @param titulo String del título de una película
#' @param img URL de la imagen de la película
#' @param norm_rating Numeric. Rating de recomendación de la película
#'
#' @return Div de clase `card` con la imagen, título y texto de recomendación 
#' para una película
bs_card <- function(titulo, img, norm_rating) {
  shiny::div(
    class="card mb-3 col-sm-4",
    shiny::img(src = img,
               class = "card-img-top"),
    shiny::div(
      class="card-body",
      shiny::h5(
        class="card-title", 
        titulo
      ),
      shiny::p(
        class="card-text", 
        glue::glue(norm_rating, "% recomendado para ti")
      ),
      shiny::a(
        href = "", 
        class = "btn btn-primary", 
        "Ver película"
        )
    )
    )
}

#' Generar listas de cards de películas a partir de los dataframes de 
#' recomendaciones
#'
#' @param df_reco Dataframe que contiene items recomendados y ratings estimados
#' @param df_peliculas Dataframe con el título y URL de la película
#'
#' @return `tagList` con una lista de `cards` de películas recomendadas
generar_reco_cards <- function(df_reco, df_peliculas) {

  reco_cards <- htmltools::tagList() # generamos lista vacía de tags de HTML
  
  for (i in 1:10){
    reco_cards[[i]] <- bs_card(titulo = df_reco$item[i], 
                               img = df_peliculas[df_peliculas$titulo == df_reco$item[i], "img_url"],
                               norm_rating = df_reco$norm_rating[i])
  }
  return(reco_cards)
}


#' Generador de recomendaciones dado un algoritmo, los parámetros del modelo
#' y una lista de películas a excluir.
#'
#' @param train_data `realRatingMatrix` con datos de entrenamiento
#' @param user_data `realRatingMatrix` con datos del usuario a recomendar
#' @param algoritmo Método de recomendación de recommenderlab
#' @param params Parámetros del algoritmo de recomendación
#' @param excluir Lista de películas a excluir de la recomendación
#'
#' @return Dataframe que contiene items recomendados y ratings estimados
recomendar_pelicula <- function(train_data, user_data, algoritmo, params, excluir) {
  Recommender(train_data, algoritmo, params) %>%
    predict(user_data, type = "ratings") %>% 
    as("data.frame") %>% 
    arrange(desc(rating)) %>%
    filter(!item %in% excluir) %>%
    head(10) %>%
    mutate(norm_rating = round(normalizar_rating(rating),0))
}


#' Normalización de valoraciones de 1-5 entre 0 y 100.
#'
#' @param rating Valoración de 1-5
#'
#' @return Numeric. Rating normalizado entre 0-100
normalizar_rating <- function(rating) {
  norm_rating <- (rating - 1) / 4 * 100
  ifelse(norm_rating > 100, 100, norm_rating)
}