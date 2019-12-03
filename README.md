# MATE21 - Tópicos em Computação Visual III
### Professor: Danilo Coimbra

### Aluno: Marcus Freire

A base de referência é a do SISTEMA DE INFORMAÇÃO DE MORTALIDADE - SIM, para os anos de 2006 à 2017 para o estado da Bahia, disponibilizado pelo [DATASUS](http://datasus.saude.gov.br/informacoes-de-saude/servicos2/transferencia-de-arquivos), assim como a base de municípios do Brasil, onde é filtrado pelos municípios da Bahia. Outra base para a coleta do IDH e GINI assim como outros indicadores foi disponibilizados pelo [ATLASBRASIL](http://www.atlasbrasil.org.br/).
Filtrando variáveis para visualização
Como todas as três bases estão contém um número de variáveis muito grande, então foi filtrado das três bases as variáveis que será importante para a visualização.

* SIM
	- Está base contém 92 variáveis, dessas foi escolhida:
  * IDADE : 
    - Idade da pessoa ná época do Óbito
	* Sexo: 
	  - 1 - M, 
	  - 2 - F
	* RACACOR:
	  - 1 -Branca
	  - 2 -Preta
	  - 3 -Amarela
	  - 4 -Parda
	  - 5 -Indígena
  * CODMUNOCOR:
    - Município de ocorrência do óbito, conforme códigos IBGE.
  * CAUSABAS:
    - Causa básica, conforme a Classificação Internacional de Doença (CID), 10a. Revisão
    
A Classificação Estatística Internacional de Doenças e Problemas Relacionados com a Saúde (CID; em inglês: International Statistical Classification of Diseases and Related Health Problems, ICD). A CID é publicada pela Organização Mundial de Saúde (OMS) e é usada globalmente para estatísticas de morbilidade e de mortalidade, como no nosso caso do SIM é utilizado o CID10 para indicar a causa da morte. para o tratamento dessa variável CAUSABAS, foi utilizado como referência uma tabela disponibilizada pelo DATASUS em [link](http://tabnet.datasus.gov.br/cgi/sih/mxcid10.htm).  
