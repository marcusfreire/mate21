## Leitura
#Municípios
munic = read.csv("/home/marcus/Documentos/UFBA/mate21_visualizacao/trabalho/data/ibge_munic/tb_municip.csv",sep=";",header = F)
# SIM
sim =read.csv("/home/marcus/Documentos/UFBA/mate21_visualizacao/trabalho/data/sim_total/sim.csv")


colnames(munic)=c("co_municip","co_municdv","co_status","co_tipo","ds_nome","ds_nomepad","ds_observ","co_alter","co_alterdv","co_regiao","co_uf","in_capital","in_amazleg","in_semiar","in_frontzn","in_frontfx","in_pobreza","dt_instal","dt_extin","co_sucess","nu_ordem","nu_ordmap","nu_latitud","nu_longit","nu_altitud","nu_area")
col_select = c("co_municip","co_tipo","ds_nomepad","co_regiao","co_uf","in_capital","in_amazleg","in_semiar","in_frontzn","in_frontfx","in_pobreza","nu_latitud","nu_longit","nu_altitud","nu_area")

#Filtro pelos municipios ativos
munic_geo = munic %>% 
  filter(co_status == "ATIVO") %>% 
  select(codmunocor = "co_municip","ds_nomepad","in_pobreza","nu_latitud","nu_longit")

a = sim %>% group_by(codmunocor,causabas,ano) %>% tally()

# Verificando as principais causas de óbitos
a %>% group_by(causabas) %>% tally(sort = T)
#causabas      n
#1 IX       228468
#2 XX       137384
#3 XVIII    126769
#4 II       114339
#5 X         71009

sim = sim %>% filter(causabas %in% c("IX","XX","XVIII","II","X","XX"))
#Principais cidades,
cidades = a %>% group_by(codmunocor) %>% tally(sort = T)
#      codmunocor      n
#1     292740 162288
#2     291080  35315
#3     293330  22780
#4     291480  21769
#5     291360  11611
#6     291840  11408
#7     291800  10829
#8     293135   9751
#9     290570   9402
#10     290070   9108

munic_tot = munic_geo %>% inner_join(cidades)

#a =munic_tot %>% filter(in_pobreza == "S")

munic_pobreza = c("291170","291750","293010","291640","293050","292660","290460","290390","292510","290270")
munic_n_pobreza = c("292740","291080","293330","291480","291360","291840","291800","293135","290570","290070")

a = a %>% filter(codmunocor %in% c(munic_n_pobreza,munic_pobreza))

a = a %>% inner_join(munic_geo)

write.csv(a,"/home/marcus/Documentos/repositorios/mate21/data/munic.csv",row.names = F)

#Usando o spark CAUSABAS x ANO
munic_tbl <- sdf_copy_to(sc, munic, name = "munic_tbl", overwrite = TRUE)
x =munic_tbl %>% select(causabas,ano,n) %>% sdf_pivot(ano ~ causabas,
                       fun.aggregate = list(n = "sum")) 
x %>% show()

x = sdf_coalesce(x,1)
spark_write_csv(x,path = "/home/marcus/Documentos/UFBA/mate21_visualizacao/trabalho/data/causabas_x_ano/", header = T,mode = "overwrite")

