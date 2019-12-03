#will install the packages library if you don't have it
packages = c("read.dbc","dplyr","tidyr","sparklyr","shinydashboard","shiny","leaflet","DT","plotly")
for(pck in packages){
  if(!is.element(pck, installed.packages()[,1]))
    {install.packages(pck)
  }else {library(pck,character.only = T)}
}
#Municípios
## Leitura
munic = read.csv("/home/marcus/Documentos/UFBA/mate21_visualizacao/trabalho/data/ibge_munic/tb_municip.csv",sep=";",header = F)
levels(as.factor(munic$V3))
munic %>% filter(V3 == "ATIVO") %>% count()

colnames(munic)=c("co_municip","co_municdv","co_status","co_tipo","ds_nome","ds_nomepad","ds_observ","co_alter","co_alterdv","co_regiao","co_uf","in_capital","in_amazleg","in_semiar","in_frontzn","in_frontfx","in_pobreza","dt_instal","dt_extin","co_sucess","nu_ordem","nu_ordmap","nu_latitud","nu_longit","nu_altitud","nu_area")
col_select = c("co_municip","co_tipo","ds_nomepad","co_regiao","co_uf","in_capital","in_amazleg","in_semiar","in_frontzn","in_frontfx","in_pobreza","nu_latitud","nu_longit","nu_altitud","nu_area")

munic_geo = munic %>% 
  filter(co_status == "ATIVO") %>% 
  select(CODMUNOCOR = "co_municip","ds_nomepad","in_pobreza","nu_latitud","nu_longit")

teste = munic %>% filter(co_status == "ATIVO") %>% select(col_select)
############
# SIM
files = list.files("/home/marcus/Documentos/UFBA/mate21_visualizacao/trabalho/data/sim/2016")
sim =read.dbc("/home/marcus/Documentos/UFBA/mate21_visualizacao/trabalho/data/sim/DOBA2006.dbc")

colnames(sim)
sim%>% group_by(RACACOR) %>% count(sort = T)
a = sim %>% select(CODMUNOCOR,CAUSABAS)
a= a %>% mutate(rules = case_when(substr(CAUSABAS,1,1) %in% c("A","B") ~ "I",
                               substr(CAUSABAS,1,1)=="C" ~ "II",
                               substr(CAUSABAS,1,1)=="D" & substr(CAUSABAS,2,2)<=4 ~ "II",
                               substr(CAUSABAS,1,1)=="D" & substr(CAUSABAS,2,2)>4  ~ "III",
                               substr(CAUSABAS,1,1)=="E" ~ "IV",
                               substr(CAUSABAS,1,1)=="F" ~ "V",
                               substr(CAUSABAS,1,1)=="G" ~ "VI",
                               substr(CAUSABAS,1,1)=="H" & substr(CAUSABAS,2,2)<=5 ~ "VII",
                               substr(CAUSABAS,1,1)=="H" & substr(CAUSABAS,2,2)> 5 ~ "VIII",
                               substr(CAUSABAS,1,1)=="I" ~ "IX",
                               substr(CAUSABAS,1,1)=="J" ~ "X",
                               substr(CAUSABAS,1,1)=="K" ~ "XI",
                               substr(CAUSABAS,1,1)=="L" ~ "XII",
                               substr(CAUSABAS,1,1)=="M" ~ "XIII",
                               substr(CAUSABAS,1,1)=="N" ~ "XIV",
                               substr(CAUSABAS,1,1)=="O" ~ "XV",
                               substr(CAUSABAS,1,1)=="P" ~ "XVI",
                               substr(CAUSABAS,1,1)=="Q" ~ "XVII",
                               substr(CAUSABAS,1,1)=="R" ~ "XVIII",
                               substr(CAUSABAS,1,1) %in% c("S","T") ~ "XIX",
                               substr(CAUSABAS,1,1) %in% c("V","W","X","Y") ~ "XX",
                               substr(CAUSABAS,1,1)=="Z" ~ "XXI",
                               substr(CAUSABAS,1,1)=="U" ~ "99"))

a %>% group_by(CODMUNOCOR) %>% count(sort = T)

a_tbl <- sdf_copy_to(sc, a, name = "a_tbl", overwrite = TRUE)

x =a_tbl %>% sdf_pivot(CODMUNOCOR ~ rules,
                fun.aggregate = list(CODMUNOCOR = "count"))

y = a %>% group_by(CODMUNOCOR) %>% count(sort = T)

y_tbl <- sdf_copy_to(sc, y, name = "y_tbl", overwrite = TRUE)

munic_tbl <- sdf_copy_to(sc, munic_geo, name = "munic_tbl", overwrite = TRUE)

munic_tot = x %>% inner_join(y_tbl,copy = T)

munic_tot = munic_tot %>% inner_join(munic_tbl,copy = T)

munic_tot
x_1 = sdf_coalesce(munic_tot,1)
spark_write_csv(x_1,path = "/home/marcus/Documentos/UFBA/mate21_visualizacao/trabalho/data/causabas_munic/", header = T,mode = "overwrite")

# Priâmide Etária
b = sim %>% select(IDADE,SEXO,CAUSABAS)
b  %>% group_by(substr(IDADE,1,1)) %>% tally()

b  %>% group_by(SEXO) %>% tally()

b= b %>% mutate(idade = case_when(substr(IDADE,1,1) %in% c(0,1,2,3) ~ "< 1",
                                  substr(IDADE,1,1)== 5 ~ ">= 100",
                                  IDADE == "000" | substr(IDADE,1,1) == 9 ~ "ING",
                                  substr(IDADE,1,1)==4 & substr(IDADE,2,2)==0  ~ "1-9",
                                  substr(IDADE,1,1)==4 & substr(IDADE,2,2)==1  ~ "10-19",
                                  substr(IDADE,1,1)==4 & substr(IDADE,2,2)==2  ~ "20-29",
                                  substr(IDADE,1,1)==4 & substr(IDADE,2,2)==3  ~ "30-39",
                                  substr(IDADE,1,1)==4 & substr(IDADE,2,2)==4  ~ "40-49",
                                  substr(IDADE,1,1)==4 & substr(IDADE,2,2)==5  ~ "50-59",
                                  substr(IDADE,1,1)==4 & substr(IDADE,2,2)==6  ~ "60-69",
                                  substr(IDADE,1,1)==4 & substr(IDADE,2,2)==7  ~ "70-79",
                                  substr(IDADE,1,1)==4 & substr(IDADE,2,2)==8  ~ "80-89",
                                  substr(IDADE,1,1)==4 & substr(IDADE,2,2)==9  ~ "90-99",
                                  )
                )


tmp = b %>% filter(idade != "ING") %>% filter(SEXO !=0)

tmp %>% select(idade,IDADE) %>% group_by(idade) %>% tally()

teste = tmp %>% group_by(idade, SEXO) %>% tally()
tmp2 = tmp %>% group_by(idade) %>% tally()
teste = teste %>% mutate(nn =case_when(SEXO == 2 ~ paste("-",n),
                                   SEXO == 1 ~ paste(n)))
library(plotly)
plot_ly(teste, x = ~nn, y = ~idade, color = ~SEXO) %>%
  add_bars(orientation = "h",
           hoverinfo = "y+text+name", text = ~n, 
           colors = c("blue", "green")) %>%
  layout(bargap = 0.1, barmode = "overlay", 
         title = "BA, 2016", 
         xaxis = list(tickmode = "array", 
                      tickvals = c(-8000, -4000, 0, 4000,8000),
                      ticktext = c("8k", "4", "0", "4k", "8k"), 
                    title = "Population"), 
         yaxis = list(title = "Age"))




n1 <- ggplot(teste, aes(x = idade, y = n, fill = SEXO)) + 
      geom_bar(subset = .(SEXO == 2), stat = "identity") + 
      geom_bar(subset = .(SEXO == 1), stat = "identity") + 
      #scale_y_continuous(breaks = seq(-10000, 10000, 4000), 
#                         labels = paste0(as.character(c(seq(9, 0, -1), seq(1, 9, 1))), "m")) + 
      coord_flip() + 
      scale_fill_brewer(palette = "Set1") + 
      theme_bw()

n1
paste0(as.character(c(seq(9, 0, -1), seq(1, 9, 1))))
sim %>% filter(is.null(CAUSABAS)) %>% count()

head(sim$CAUSABAS)
sim %>% filter(CAUSABAS == "X959") %>% count()


sim %>% group_by(CAUSABAS) %>% count(sort = T)


sum(a$n)

sapply(sim, function(x) sum(is.na(x)))

b = b%>% select(causabas = rules, idade,SEXO)

c = b%>% group_by(causabas,idade,SEXO) %>% tally()

b%>% group_by(causabas) %>% tally(sort = T)
