# Definindo o Pipe e funções
source("r/graficos.R")
source("r/funcoes.R")

# Links de download gerados pela NASA
file_names <- list.files(path = "data-raw/",
                    pattern = ".txt",
                    full.names = TRUE)



le_separa <- function(caminho){
  caminho |>
  readr::read_table(col_names = FALSE,
                    col_types = "c") |>
  dplyr::pull(X1) |>
  stringr::str_split(",",simplify = TRUE) |> t()
  }
links_1<-le_separa(file_names[1])
links_2<-le_separa(file_names[2])
links<-rbind(links_1,links_2)



# Definindo os caminhos e nomes dos arquivos
n_split <- lengths(stringr::str_split(links[2],"/"))
files_csv <- stringr::str_split(links,"/",simplify = TRUE)[,n_split]
files_csv <- paste0("data-raw/csv/",files_csv)

# Download dos arquivos .csv
# purrr::map2(links,
#              files_csv,
#              .f=download.file,mode="wb")


#
# faxina_co2 <- function(arquivo, col, valor_perdido){
#   da <- readr::read_csv(arquivo) %>%
#     janitor::clean_names() %>%
#     dplyr::filter({{col}} != valor_perdido)
#   readr::write_csv(da,arquivo)
# }
#
#
# purrr::map(files_csv, faxina_co2,
#            col=xco2_moles_mole_1,
#            valor_perdido= -999999)

# oco2 <- purrr::map_dfr(files_csv, ~readr::read_csv(.x))
# readr::write_rds(oco2,"data/oco2.rds")
oco2 <- readr::read_rds("data/oco2.rds")
dplyr::glimpse(oco2)

oco2<-oco2 |>
  dplyr::mutate(
    xco2 = xco2_moles_mole_1*1e06,
    data = lubridate::ymd_hms(time_yyyymmddhhmmss),
    ano = lubridate::year(data),
    mes = lubridate::month(data),
    dia = lubridate::day(data),
    dia_semana = lubridate::wday(data))

oco2 |>
  ggplot2::ggplot(ggplot2::aes(x=data,y=xco2)) +
  ggplot2::geom_point(color="blue") +
  ggplot2::geom_line(color="red")
