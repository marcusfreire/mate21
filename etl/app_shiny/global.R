#will install the packages library if you don't have it
packages = c("dplyr","tidyr","shinydashboard","shiny","leaflet","DT","httr","RCurl","rsconnect","plotly")
for(pck in packages){
	  if(!is.element(pck, installed.packages()[,1]))
		    {install.packages(pck)
  }else {library(pck,character.only = T)}
}

# Leitura das bases #
sim = read.csv(text=getURL("https://raw.githubusercontent.com/marcusfreire/mate21/master/data/sim_total/sim_coordebadas_paralelas.csv"), header=T)
munic = read.csv(text=getURL("https://raw.githubusercontent.com/marcusfreire/mate21/master/data/causabas_munic/part-00000-8ce75990-bbd1-485c-9842-adfa444c295b-c000.csv"), header=T)
    
munic$nu_longit = as.numeric(sub(",",".",munic$nu_longit))
munic$nu_latitud = as.numeric(sub(",",".",munic$nu_latitud))    
