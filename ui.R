library(shiny)
library(shinythemes)
library(dplyr)
library(rmarkdown)

relevant_attraction_data <- read.csv("relevant_attraction_data.csv")%>% arrange(kecamatan)
kecamatan_list <- as.list(relevant_attraction_data$kecamatan)

# Convert the first alphabet of each value and the first alphabet after ' ' to uppercase
kecamatan_list <- lapply(kecamatan_list, function(x) {
  words <- strsplit(x, " ")[[1]]
  words <- paste0(toupper(substring(words, 1, 1)), substring(words, 2))
  return(paste(words, collapse = " "))
})


fluidPage(theme = shinytheme("united"),
          navbarPage("Spatial House Price Prediction App",
                     # Page header
                     tabPanel("Home",
                              
                              # Choose Model
                              sidebarPanel(
                                HTML("<h3>Choose Model</h3>"),
                                
                                selectInput(
                                  "model",
                                  label = "Model:",
                                  choices = list("SAR" = "sar",
                                                 "SEM" = "sem"
                                  ),
                                  selected = "sar"
                                ),
                                
                              ),
                              
                              # Input values
                              sidebarPanel(
                                HTML("<h3>Input Values</h3>"),
                                
                                textInput("luas_tanah", "Luas Tanah (m^2):", "0"),
                                textInput("luas_gedung", "Luas Gedung (m^2): ", "0"),
                                textInput("daya_listrik", "Daya Listrik (Watt): ","0"),
                                textInput("banyak_kamar_tidur", "Banyak Kamar Tidur: ","0"),
                                textInput("banyak_toilet", "Banyak Toilet: ","0"),
                                textInput("lebar_jalan", "Lebar Jalan (X cars): ","0"),
                                
                                # Input Kelurahan
                                selectInput(
                                  "kecamatan", 
                                  label="Kecamatan:",
                                  choices = kecamatan_list,
                                  selected = "Ancol"
                                ),
                                
                                actionButton("submitbutton", "Submit", class = "btn btn-primary")
                              ),
                              
                              mainPanel(
                                tags$label(h3('Harga Prediksi')),
                                verbatimTextOutput('calculation_result')
                              )
                              
                     ),
                     tabPanel("Instructions",
                              div(includeMarkdown("instructions.md"),
                                  align="justify")
                     ),
                     tabPanel("About",
                              div(includeMarkdown("about.md"),
                                  align="justify")
                     )
                     
          )   
)