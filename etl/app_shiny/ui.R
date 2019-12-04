ui <- dashboardPage(
  dashboardHeader(title = "SIM"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Overview", tabName = "aba1", icon = icon("info")),
      menuItem("Maps", tabName = "aba2", icon = icon("globe")),
      menuItem("Coordenadas Paralelas", tabName = "aba3", icon = icon("clipboard"))
    ),
    sidebarMenuOutput("menu")
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "aba1",
              fluidRow(
                h3("SIM - SISTEMA DE INFORMAÇÃO SOBRE MORTALIDADE"),
                #column(4,h3("Escolha o(s) ano(s) de ocorrência(s)")),
                sidebarLayout(
                  column(8,offset = 1,sliderInput(
                    inputId = "i_year",
                    label = "Ano(s) de Ocorrência(s)", min = 2006, max = 2017,
                    sep = "",
                    value = c(2006, 2006)
                    
                  )),
                  
                  mainPanel(width = 1,
                            DT::dataTableOutput(outputId = "mtable")
                  )
                )
                  
              ),
              fluidRow(
                box(plotlyOutput("piramideetaria")),
              
                box(plotlyOutput("causabas"))
              ),
              fluidRow(
                column(7,offset = 6,
                h4("Causa básica, conforme a Classificação Internacional de Doença (CID)."),
                h5("IX - Doenças do aparelho circulatório;"),
                h5("II - Neoplasmas [tumores];"),
                h5("XX - Causas externas de morbidade e de mortalidade;"),
                h5("X - Doenças do aparelho respiratório;"),
                h5("XVII - Sintomas, sinais e achados anormais de exames clínicos e de laboratório."))
              ),
              
      ),
      tabItem(tabName = "aba2",
            column(6,leafletOutput(outputId = "map_ba",height = 480)),
            column(5,dataTableOutput('my_table'))
       ),
      tabItem(tabName = "aba3",
              plotlyOutput("coordenadaspolares")
      )
    )
  )
)