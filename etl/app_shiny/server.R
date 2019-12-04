server <- shinyServer(function(input, output, session) { 
 
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
        lat =~nu_latitud,popup = paste(munic$ds_nomepad,": ",munic$n))
  })
  
  output$coordenadaspolares <- renderPlotly({
    source("coordenadas_paralelas.R")
    p
  })
  
  output$piramideetaria <- renderPlotly({
    idade = sim %>% filter((ano >= 2008) & (ano <= 2010)) %>%
      select(idade,sexo,n)%>%
      group_by(idade, sexo) %>% summarize_all(funs(sum)) %>%
      mutate(n =case_when(sexo == 'F' ~ paste0("-",n),
                          sexo == 'M' ~ paste0(n)))
    
    
    sort(c(levels(sim$idade),"M_q_100+"))
    max = idade %>% summarise(max = max(n))
    max = sort(as.integer(max$max),decreasing = T)[1]
    max = round((max/1000))
    
    plot_ly(idade, x = ~n, y = ~idade, color = ~sexo) %>%
      add_bars(orientation = "h",
               hoverinfo = "y+text+name", text = ~n, 
               colors = c("red", "blue")) %>%
      layout(bargap = 0.1, barmode = "overlay", 
             title = "BA, 2016", 
             xaxis = list(tickmode = "array", 
                          tickvals = c(-1000*max, round(max/2)*-1000, 0, round(max/2)*1000,max*1000),
                          ticktext = c(paste0(max,"k"), paste0(round(max/2),"k"), "0", paste0(round(max/2),"k"),paste0(max,"k")), 
                          title = "População"), 
             yaxis = list(title = "Idade"))
    
  })
  
  
})

#shinyApp(ui, server)