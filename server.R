library(shiny)
library(shinythemes)
library(dplyr)
library(spatialreg)

# install.packages("markdown")
library(rmarkdown)

sar_model <- readRDS("sar_model6.rds")
sem_model <- readRDS("sem_model6.rds")

relevant_attraction_data <- read.csv("relevant_attraction_data.csv")%>% arrange(kecamatan)
kecamatan_list <- as.list(relevant_attraction_data$kecamatan)

# Convert the first alphabet of each value and the first alphabet after ' ' to uppercase
kecamatan_list <- lapply(kecamatan_list, function(x) {
  words <- strsplit(x, " ")[[1]]
  words <- paste0(toupper(substring(words, 1, 1)), substring(words, 2))
  return(paste(words, collapse = " "))
})

shinyServer(function(input, output, session){
  
  options(scipen = 10)
  
  # Input Data
  datasetInput <- reactive({ 
    
    # Assuming input$kecamatan holds the value for kecamatan
    selected_kecamatan <- tolower(input$kecamatan)
    
    # Filter relevant_attraction_data based on kecamatan
    filtered_data <- relevant_attraction_data %>%
      filter(kecamatan == selected_kecamatan) %>%
      select(halte,
             apotek,
             saluran,
             sungai,
             cagar_buda,
             danau_embu,
             daya_tarik,
             gdf_bandar,
             spbg,
             pemerintah,
             jumlah_populasi)
    
    df <- data.frame(
      Name = c("luas_tanah",
               "luas_gedung",
               "daya_listrik",
               "banyak_kamar_tidur",
               "banyak_toilet",
               "lebar_jalan",
               "halte",
               "apotek",
               "saluran",
               "sungai",
               "cagar_buda",
               "danau_embu",
               "daya_tarik",
               "gdf_bandar",
               "spbg",
               "pemerintah",
               "jumlah_populasi",
               "log_transformed_harga"
      ),
      Value = as.numeric(c(input$luas_tanah,
                           input$luas_gedung,
                           input$daya_listrik,
                           input$banyak_kamar_tidur,
                           input$banyak_toilet,
                           input$lebar_jalan,
                           filtered_data,
                           0
      )),
      stringsAsFactors = FALSE
    )
    
    df <-as.data.frame(t(df$Value))
    colnames(df) <- c("luas_tanah",
                      "luas_gedung",
                      "daya_listrik",
                      "banyak_kamar_tidur",
                      "banyak_toilet",
                      "lebar_jalan",
                      "halte",
                      "apotek",
                      "saluran",
                      "sungai",
                      "cagar_buda",
                      "danau_embu",
                      "daya_tarik",
                      "gdf_bandar",
                      "spbg",
                      "pemerintah",
                      "jumlah_populasi",
                      "log_transformed_harga"
    )
    
    
    formula <- log_transformed_harga ~ banyak_kamar_tidur+banyak_toilet+luas_gedung+daya_listrik+lebar_jalan+
      jumlah_populasi+luas_tanah+halte+apotek+saluran+sungai+cagar_buda+danau_embu+daya_tarik+gdf_bandar+
      spbg+pemerintah
    
    options(scipen=12)
    
    if(input$model=='sem'){
      coefficients <- coef(sem_model)
      predictions <- predict(sem_model, newdata = df)
    }
    else if (input$model=='sar'){
      coefficients <- coef(sar_model)
      predictions <- predict(sar_model, newdata = df)
    }
    
    print(predictions)
    
  })
  
  # Status/Output Text Box
  output$calculation_result <- renderPrint({
    if (input$submitbutton>0){
      isolate(datasetInput())
      # isolate({
        # exp_predictions <- exp(datasetInput())
        # paste("Rp", format(exp_predictions, big.mark = ".", decimal.mark = ",", trim = TRUE))
      # })
    }
    else{
      return("Server is ready for calculation")
    }
  })
})