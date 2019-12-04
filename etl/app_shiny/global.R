# Fui obrigado a comentar a chamada dos pacotes, pois estava dando erro no shinnyappio
#will install the packages library if you don't have it
#setwd(paste0(dirname(rstudioapi::getActiveDocumentContext()$path)))
#getwd()
#rm(list = ls()) 
#packages = c("dplyr","tidyr","shinydashboard","shiny","leaflet","DT","httr","RCurl","rsconnect","plotly")
#for(pck in packages){
#	  if(!is.element(pck, installed.packages()[,1]))
#		    {install.packages(pck)
#  }else {library(pck,character.only = T)}
#}
require("dplyr")
require("tidyr")
require("shinydashboard")
require("shiny")
require("leaflet")
require("DT")
require("httr")
require("RCurl")
require("plotly")
# Leitura das bases #
sim = read.csv(text=getURL("https://raw.githubusercontent.com/marcusfreire/mate21/master/data/sim_total/sim_coordebadas_paralelas.csv"), header=T)
munic = read.csv(text=getURL("https://raw.githubusercontent.com/marcusfreire/mate21/master/data/munic_sim_causabas_geo.csv"), header=T)
causas_obitos = read.csv(text = getURL("https://raw.githubusercontent.com/marcusfreire/mate21/master/data/causacas_x_ano.csv"), header=T)    

munic$nu_longit = as.numeric(sub(",",".",munic$nu_longit))
munic$nu_latitud = as.numeric(sub(",",".",munic$nu_latitud))

a = munic %>% select(codmunocor,n) %>% group_by(codmunocor) %>% summarize_all(list(sum))
a = a %>% select(codmunocor,total = n)
munic = munic %>% inner_join(a)
#munic = munic %>% mutate(legenda = paste(munic$ds_nomepad,": ",munic$total))

c = munic %>% group_by(codmunocor,in_pobreza,ds_nomepad,nu_latitud,nu_longit) %>% tally()

b = a %>% left_join(c) 

c = b %>% select(nome = ds_nomepad,obitos = total,in_pobreza)
#causas_obitos = munic %>% select(causabas,ano,n) %>% group_by(causabas,ano) %>% summarize_all(list(sum))

b = b %>%  mutate(legenda = paste(b$ds_nomepad,": ",b$total))
b = b %>% select(nu_latitud,nu_longit,legenda,in_pobreza,total)
b$in_pobreza = as.factor(b$in_pobreza)

