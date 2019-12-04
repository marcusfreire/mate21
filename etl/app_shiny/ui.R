ui <- dashboardPage(
  dashboardHeader(title = "Overview"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Overview", tabName = "aba1", icon = icon("info")),
      menuItem("Coordenadas Paralelas", tabName = "aba2", icon = icon("bookmark")),
      menuItem("Maps", tabName = "aba3", icon = icon("globe"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "aba3",
              sidebarLayout(
                column(12,sidebarPanel(selectInput(
                  inputId = "i_title_type",
                  label = "Incidência de pobreza :",
                  choices = c("All", unique(as.character(munic$in_pobreza))),
                  selected = "All"
                )),
                
                column(6,sliderInput(
                  inputId = "i_year",
                  label = "Year", min = 2006, max = 2017,
                  sep = "",
                  value = c(2010, 2017)
                  
                )),
                column(1,actionButton('select', 'Select'))
                
                ),
                
                mainPanel(width = 12,
                          DT::dataTableOutput(outputId = "mtable")
                )
              ),
              
            leafletOutput(outputId = "map_ba")
       ),
      tabItem(tabName = "aba2",
              plotlyOutput("coordenadaspolares")
      )
      ,
      tabItem(tabName = "aba1",
              plotlyOutput("piramideetaria")
      )
    )
  )
)