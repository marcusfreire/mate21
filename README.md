# MATE21 - Tópicos em Computação Visual III
### Professor: Danilo Coimbra

### Aluno: Marcus Freire

[![Link contendo vídeo explicando a aplicação](https://raw.githubusercontent.com/marcusfreire/mate21/master/metadata/img/tela_video.png)](https://youtu.be/3vevuR38xtQ)

[![Link contendo a aplicação](https://raw.githubusercontent.com/marcusfreire/mate21/master/metadata/img/tela_app.png)](https://marcusfreire.shinyapps.io/mate_21/)

A base de referência é a do SISTEMA DE INFORMAÇÃO DE MORTALIDADE - SIM, para os anos de 2006 a 2017 do estado da Bahia, disponibilizada pelo  [DATASUS](http://datasus.saude.gov.br/informacoes-de-saude/servicos2/transferencia-de-arquivos), assim como a base de municípios do Brasil, onde é filtrado pelos municípios baianos. As informações de **LATITUDE**, **LONGITUDE** e **IN_POBREZA** fazem parte da relação de municípios de extrema pobreza indicados pelo [IBGE DOWNLOAD](https://www.ibge.gov.br/estatisticas/downloads-estatisticas.html), sendo possível filtrar as variáveis para visualização. Como todas as três bases contêm um número de variáveis muito grande, então foi filtrado das três bases as variáveis que são importantes para a visualização.

* **SIM**
	- Esta base contêm 92 variáveis, dessas foi escolhida:
  * **IDADE** : 
    - Idade da pessoa ná época do Óbito
	* **Sexo**: 
	  - 1 - M, 
	  - 2 - F
	* **RACACOR**:
	  - 1 -Branca
	  - 2 -Preta
	  - 3 -Amarela
	  - 4 -Parda
	  - 5 -Indígena
  * **CODMUNOCOR**:
    - Município de ocorrência do óbito, conforme códigos IBGE.
  * **CAUSABAS**:
    - Causa básica, conforme a Classificação Internacional de Doença (CID), 10a. Revisão
    
A Classificação Estatística Internacional de Doenças e Problemas Relacionados com a Saúde (CID; em inglês: International Statistical Classification of Diseases and Related Health Problems, ICD), é publicada pela Organização Mundial de Saúde (OMS) e é usada globalmente para estatísticas de morbilidade e de mortalidade. Em nosso caso é utilizado o SIM, e o CID10 para indicar a causa da morte. Para o tratamento dessa variável CAUSABAS foi utilizado como referência uma tabela disponibilizada pelo DATASUS em [link](http://tabnet.datasus.gov.br/cgi/sih/mxcid10.htm).  
