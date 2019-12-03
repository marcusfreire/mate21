#will install the packages library if you don't have it
packages = c("read.dbc","dplyr","tidyr","sparklyr","shinydashboard","shiny","leaflet","DT")
for(pck in packages){
  if(!is.element(pck, installed.packages()[,1]))
  {install.packages(pck)
  }else {library(pck,character.only = T)}
}

server <- shinyServer(function(input, output, session) { 
  munic = read.csv(file = "/home/marcus/Documentos/UFBA/mate21_visualizacao/trabalho/data/causabas_munic/part-00000-8ce75990-bbd1-485c-9842-adfa444c295b-c000.csv")
  #munic = munic[1:10,]
  munic$nu_longit = as.numeric(sub(",",".",munic$nu_longit))
  munic$nu_latitud = as.numeric(sub(",",".",munic$nu_latitud))
  
  ## app.R ##

  
  filtered_title_type <- reactive({
    if(input$i_title_type == "All"){
      munic
    } else {
      munic %>%
        filter(in_pobreza == input$i_title_type)
    }
  })
  
  fully_filtered <- eventReactive(input$select, {
    if (input$select==0){
      munic
    }
    filtered_title_type()
  })
  
  output$map_ba<-renderLeaflet({
    #cidades = munic %>%
      leaflet() %>%
      addTiles() %>%  # Add default OpenStreetMap map tiles
      clearMarkers() %>%
      clearPopups() %>%
      addMarkers(
        data = fully_filtered(),
        lng =~nu_longit , 
        lat =~nu_latitud,popup = ~ds_nomepad)
  })
  
})

#shinyApp(ui, server)