sim = read.csv("/home/marcus/Documentos/UFBA/mate21_visualizacao/trabalho/data/sim_total/sim_coordebadas_paralelas.csv")

idade = sim %>% filter((ano >= 2006) & (ano <= 2017)) %>%
        filter(idade != 'ING') %>%
        select(idade,sexo,n)%>%
        group_by(idade, sexo) %>% summarize_all(funs(sum)) %>%
        mutate(n =case_when(sexo == 'F' ~ paste("-",n),
                             sexo == 'M' ~ paste(n))) %>%
        mutate(idade =case_when(idade == '>= 100' ~ paste("maior que 100"),
                                idade != '>=100' ~ paste(idade)))
max =idade %>% summarise(max(n))
max = as.integer(max[1,1])


plot_ly(idade, x = ~n, y = ~idade, color = ~sexo) %>%
  add_bars(orientation = "h",
           hoverinfo = "y+text+name", text = ~n, 
           colors = c("red", "blue")) %>%
  layout(bargap = 0.1, barmode = "overlay", 
         title = "BA, 2016", 
         xaxis = list(tickmode = "array", 
                      tickvals = c(max*-1, round(max/2)*-1, 0, round(max/2),max),
                      ticktext = c(paste0(substr(max,1,2),"k"), paste0(substr(round(max/2),1,2),"k"), "0", paste0(substr(round(max/2),1,2),"k"),paste0(substr(max,1,2),"k")), 
                      title = "População"), 
         yaxis = list(title = "Idade"))

                                                