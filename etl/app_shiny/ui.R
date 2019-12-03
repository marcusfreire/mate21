ui <- dashboardPage(
  dashboardHeader(title = "Overview"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Maps", tabName = "aba1", icon = icon("globe"))
    )
  ),
  dashboardBody(
    fluidRow(sidebarLayout(
      column(12,sidebarPanel(selectInput(
                     inputId = "i_title_type",
                     label = "Title type:",
                     choices = c("All", unique(as.character(munic$in_pobreza))),
                     selected = "All"
                   )),
                   
                   column(6,sliderInput(
                     inputId = "i_year",
                     label = "Year", min = 2010, max = 2019,
                     sep = "",
                     value = c(2010, 2017)
                     
                   )),
                   column(1,actionButton('select', 'Select'))
                   
      ),
      
      mainPanel(width = 12,
                DT::dataTableOutput(outputId = "mtable")
      )
    )),
    tabItems(
      tabItem(tabName = "aba1",
              leafletOutput(outputId = "map_ba")
              
      )
    )
  )
)