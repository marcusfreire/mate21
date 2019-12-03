####Bibliotecas para todos os processos do trabalho, caso não tenha ele irá instalar
packages = c("read.dbc","plyr","tidyr","sparklyr","shinydashboard","shiny","leaflet","DT","plotly","dplyr")
for(pck in packages){
  if(!is.element(pck, installed.packages()[,1]))
  {install.packages(pck)
  }else {library(pck,character.only = T)}
}

### conecção com o SPARK
#Sys.setenv(JAVA_HOME='/usr/lib/jvm/java-8-openjdk-amd64/jre')
#sc <- spark_connect(master = "local")
####