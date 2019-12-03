sim = read.csv("/home/marcus/Documentos/UFBA/mate21_visualizacao/trabalho/data/sim_total/sim_coordebadas_paralelas.csv")
sim = colwise(as.factor)(sim)
idade = levels(sim$idade)
ano = levels(sim$ano)
sexo = levels(sim$sexo)
racacor = levels(sim$racacor)
causabas = levels(sim$causabas)
#### pré processamento para coordenadas paralelas
sim = sim %>% mutate(causabas = case_when(causabas == "I" ~ 1,
                                          causabas == "II" ~ 2,
                                          causabas == "III" ~ 3,
                                          causabas == "IV" ~ 4,
                                          causabas == "V" ~ 5,
                                          causabas == "VI" ~ 6,
                                          causabas == "VII" ~ 7,
                                          causabas == "VIII" ~ 8,
                                          causabas == "IX" ~ 9,
                                          causabas == "X" ~ 10,
                                          causabas == "XI" ~ 11,
                                          causabas == "XII" ~ 12,
                                          causabas == "XIII" ~ 13,
                                          causabas == "XIV" ~ 14,
                                          causabas == "XV" ~ 15,
                                          causabas == "XVI" ~ 16,
                                          causabas == "XVII" ~ 17,
                                          causabas == "XVIII" ~ 18,
                                          causabas == "XX" ~ 20))

# IDADE

sim = sim %>% mutate(idade = case_when(idade == "< 1"~ 1,
                                       idade == ">= 100"~12,
                                       idade == "ING"~0,
                                       idade == "1-9"~2,
                                       idade == "10-19"~3,
                                       idade == "20-29"~4,
                                       idade == "30-39"~5,
                                       idade == "40-49"~6,
                                       idade == "50-59"~7,
                                       idade == "60-69"~8,
                                       idade == "70-79"~9,
                                       idade == "80-89"~10,
                                       idade == "90-99"~11,
)
)

# Sexo - Excluindo igual a zero e mudando de 1 para M, 2 para F
sim = sim %>% mutate(sexo = case_when(sexo == 'M'~1,
                                      sexo == 'F'~2))

# RacaCOR
sim = sim %>% mutate(racacor = case_when(racacor == 'Bra'~1,
                                         racacor == 'Pre'~2,
                                         racacor == 'Ama'~3,
                                         racacor == 'Par'~4,
                                         racacor == 'Ind'~5,
                                         racacor == 'null'~0))

sim %>% group_by(causabas) %>% tally(sort = T)
p <-  sim %>%
  plot_ly(type = 'parcoords',
          line = list(color = ~n,
                      colorscale = 'Jet',
                      showscale = TRUE,
                      reversescale = TRUE,
                      cmin = 1,
                      cmax = 2964),
          dimensions = list(
            list(tickvals = c(0,1,2,3,4,5),
                 ticktext = c("null","Bra","Pre","Ama","Par","Ind" ),
                 label = 'Raça Cor', values = ~racacor),
            list(tickvals = c(0,1,2,3,4,5,6,7,8,9,10,11,12 ),
                 ticktext = c("ING","< 1","1-9","10-19","20-29","30-39","40-49","50-59","60-69","70-79","80-89","90-99",">= 100" ),
                 label = 'Idade', values = ~idade),
            list(tickvals = c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,20),
                 ticktext = c("I","II","III","IV","V","VI","VII","VIII","IX","X","XI","XII","XIII","XIV","XV","XVI","XVII","XVIII","XX"),
                 label = 'Obito', values = ~causabas),
            list(tickvals = c(1,2),
                 ticktext = c("M","F"),
                 label = 'Sexo', values = ~sexo)
          )
          
  )
p
vet = sort(causabas)
vet
