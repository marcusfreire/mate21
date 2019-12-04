source('Documentos/UFBA/mate21_visualizacao/trabalho/etl/packeges.R')

pre_processamento = function(sim,ano_atual){
  col_select = c(idade = "IDADE",sexo = "SEXO",racacor = "RACACOR",codmunocor="CODMUNOCOR",causabas="CAUSABAS")
  sim = sim %>% select(col_select) %>% mutate(ano = ano_atual)
  # Alterando CAUSABAS dos CIDS para os capítulos
  sim = sim %>% mutate(causabas = case_when(substr(causabas,1,1) %in% c("A","B") ~ "I",
                           substr(causabas,1,1)=="C" ~ "II",
                           substr(causabas,1,1)=="D" & substr(causabas,2,2)<=4 ~ "II",
                           substr(causabas,1,1)=="D" & substr(causabas,2,2)>4  ~ "III",
                           substr(causabas,1,1)=="E" ~ "IV",
                           substr(causabas,1,1)=="F" ~ "V",
                           substr(causabas,1,1)=="G" ~ "VI",
                           substr(causabas,1,1)=="H" & substr(causabas,2,2)<=5 ~ "VII",
                           substr(causabas,1,1)=="H" & substr(causabas,2,2)> 5 ~ "VIII",
                           substr(causabas,1,1)=="I" ~ "IX",
                           substr(causabas,1,1)=="J" ~ "X",
                           substr(causabas,1,1)=="K" ~ "XI",
                           substr(causabas,1,1)=="L" ~ "XII",
                           substr(causabas,1,1)=="M" ~ "XIII",
                           substr(causabas,1,1)=="N" ~ "XIV",
                           substr(causabas,1,1)=="O" ~ "XV",
                           substr(causabas,1,1)=="P" ~ "XVI",
                           substr(causabas,1,1)=="Q" ~ "XVII",
                           substr(causabas,1,1)=="R" ~ "XVIII",
                           substr(causabas,1,1) %in% c("S","T") ~ "XIX",
                           substr(causabas,1,1) %in% c("V","W","X","Y") ~ "XX",
                           substr(causabas,1,1)=="Z" ~ "XXI",
                           substr(causabas,1,1)=="U" ~ "99"))
  
  # IDADE
  
  sim = sim %>% mutate(idade = case_when(substr(idade,1,1) %in% c(0,1,2,3) ~ "< 1",
                               substr(idade,1,1)== 5 ~ "Maior_100",
                               idade == "000" | substr(idade,1,1) == 9 ~ "ING",
                               substr(idade,1,1)==4 & substr(idade,2,2)==0  ~ "1-9",
                               substr(idade,1,1)==4 & substr(idade,2,2)==1  ~ "10-19",
                               substr(idade,1,1)==4 & substr(idade,2,2)==2  ~ "20-29",
                               substr(idade,1,1)==4 & substr(idade,2,2)==3  ~ "30-39",
                               substr(idade,1,1)==4 & substr(idade,2,2)==4  ~ "40-49",
                               substr(idade,1,1)==4 & substr(idade,2,2)==5  ~ "50-59",
                               substr(idade,1,1)==4 & substr(idade,2,2)==6  ~ "60-69",
                               substr(idade,1,1)==4 & substr(idade,2,2)==7  ~ "70-79",
                               substr(idade,1,1)==4 & substr(idade,2,2)==8  ~ "80-89",
                               substr(idade,1,1)==4 & substr(idade,2,2)==9  ~ "90-99")
            )

  sim = sim %>% mutate(idade = case_when(is.na(idade)~'ING',
                                          !is.na(idade)~paste0(idade)))
  
  # Sexo - Excluindo igual a zero e mudando de 1 para M, 2 para F
  sim = sim %>% mutate(sexo = case_when(sexo == 1 ~ 'M',
                                        sexo == 2 ~ 'F'))
  sim = sim %>% filter(sexo!=0) 
  
  # RacaCOR
  sim = sim %>% mutate(racacor = case_when(racacor == 1 ~ 'Bra',
                                           racacor == 2 ~ 'Pre',
                                           racacor == 3 ~ 'Ama',
                                           racacor == 4 ~ 'Par',
                                           racacor == 5 ~ 'Ind',
                                           is.na(racacor) ~ 'null'))
  
  # Filtrando pelas ocorrencias que ocorreram na BAHIA
  sim = sim %>% filter(substr(codmunocor,1,2)==29) %>% filter(idade != 'ING')
  
  sim
}

path = "~/Documentos/UFBA/mate21_visualizacao/trabalho/data/sim/"
ano_atual = 2006
cat("Fazendo o pré-processamanto do SIM, ano: ",ano_atual,"\n")
sim_total =read.dbc(paste0(path,"DOBA",ano_atual,".dbc"))
sim_total = pre_processamento(sim_total,ano_atual)
for (ano_atual in seq(2007,2017)) {
  cat("Fazendo o pré-processamanto do SIM, ano: ",ano_atual,"\n")
  paste0(path,"DOBA",ano_atual,".dbc")
  sim =read.dbc(paste0(path,"DOBA",ano_atual,".dbc"))
  sim = pre_processamento(sim,ano_atual)
  sim_total = bind_rows(sim_total,sim)
}
#convertendo pra factor todas as colunas
sim_total = colwise(as.factor)(sim_total)

write.csv(sim_total,file = "/home/marcus/Documentos/UFBA/mate21_visualizacao/trabalho/data/sim_total/sim.csv",row.names = F)

colnames(sim_total)

sim_coordenadas_paralelas = sim_total %>% group_by(idade,sexo,racacor,causabas,ano)%>% tally()

write.csv(sim_coordenadas_paralelas,file = "/home/marcus/Documentos/UFBA/mate21_visualizacao/trabalho/data/sim_total/sim_coordebadas_paralelas.csv",row.names = F)

sim_coordenadas_paralelas %>% group_by(causabas) %>% summarise(n = sum(n))
