server <- shinyServer(function(input, output, session) { 

  
 filtered_title_type <- reactive({
    munic %>% filter((ano >= input$i_year[1]) & (ano <= input$i_year[2]) )
    #causas_obitos %>% filter((ano >= input$i_year[1]) & (ano <= input$i_year[2]) )
    #munic %>% mutate(legenda = paste(munic$ds_nomepad,": ",munic$n))
    #munic %>%select(codmunocor,n) %>% group_by(codmunocor) %>% summarize_all(list(sum)) %>% mutate(legenda = paste(munic$ds_nomepad,": ",munic$n))
  })
 output$my_table  <- renderDataTable({
   # Filter the data
   c
 })
 output$causabas <- renderPlotly({
   ay <- list(
     overlaying = "y",
     side = "right",
     title = "second y axis"
   )
   plot_ly(causas_obitos, x = ~ano,
           mode = 'line+markers') %>%
     add_lines(y = ~II, name = "II") %>%
     add_lines(y = ~IX, name = "IX") %>%
     add_lines(y = ~X, name = "X") %>%
     add_lines(y = ~XVIII, name = "XVIII") %>%
     add_lines(y = ~XX, name = "XX") %>%
     layout(
       title = "Causa Básica", yaxis2 = ay,
       xaxis = list(title="ANO")
     )
 })
  
  fully_filtered <- eventReactive(input$select, {
    if (input$select==0){
      munic
    }
    filtered_title_type()
  })
  levels(b$in_pobreza)
  output$map_ba<-renderLeaflet({
    beatCol <- colorFactor(palette = c("green","red"), b$in_pobreza)
    m1 <- leaflet() %>%
      addTiles() %>%
      #addProviderTiles(providers$OpenStreetMap, group = 'Open SM')  %>%
      #addProviderTiles(providers$Stamen.Toner, group = 'Toner')  %>%
      #addProviderTiles(providers$Esri.NatGeoWorldMap, group = 'NG World') %>%
      #setView(lng = -12.22928, lat = -38.96003, zoom = 12) %>%
      addCircleMarkers(data = b, lat = ~nu_latitud, lng = ~nu_longit,
                       color = ~beatCol(in_pobreza), popup = b$legenda,
                       radius = ~sqrt(total/100)) %>%
      addLegend('bottomright', pal = beatCol, values = c("S","N"),
                title = 'IN POBREZA',
                opacity = 1)
    m1
    
  })
  
  output$coordenadaspolares <- renderPlotly({
    source("coordenadas_paralelas.R")
    p
  })
  
  output$piramideetaria <- renderPlotly({
    idade = sim %>% filter((ano >= input$i_year[1]) & (ano <= input$i_year[2])) %>%
      select(idade,sexo,n)%>%
      group_by(idade, sexo) %>% summarize_all(list(sum)) %>%
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
             title = paste("BA,",input$i_year[1],":",input$i_year[2]), 
             xaxis = list(tickmode = "array", 
                          tickvals = c(-1000*max, round(max/2)*-1000, 0, round(max/2)*1000,max*1000),
                          ticktext = c(paste0(max,"k"), paste0(round(max/2),"k"), "0", paste0(round(max/2),"k"),paste0(max,"k")), 
                          title = "População"), 
             yaxis = list(title = "Idade"))
    
  })
  
  
  
  
})

#shinyApp(ui, server)