*declarando a biblioteca;
libname ab "/folders/myfolders/Vendas";



/** Importando arquivo excel.  **/

PROC IMPORT DATAFILE="/folders/myfolders/Vendas/base_vendas.xlsx"
		    OUT=ab.base_vendas
		    DBMS=XLSX
		    REPLACE;
RUN;

/** mostrando resultado. **/
PROC PRINT DATA=ab.base_vendas; RUN;

/* base de dados provisoria com 2.000 Linhas*/
data teste_;
set ab.base_vendas (obs=2000 keep=Categoria Subcategoria Nome_do_Produto 
C__digo_Nota_Fiscal Valor_da_venda Lucro Estado Cidade Customer_Name Desconto__);

run;


/* crie uma base de dados permanente com tabelas que fazem parte do projeto  */
data ab.base_vendas_v2;
set teste_;

if Valor_da_venda > 1000
	then bateu_meta = "SIM";
	else bateu_meta = "NAO";
label bateu_meta = "Marca SIM para aqueles que venderam acima R$ 1.000 e NÂO caso contrário";	

run;

*Visualizar a base de dados com 100 Linhas;
proc print
data=ab.base_vendas_v2(obs=100);
run;

/* para obter informações sobre quantos vendedores conseguiram Alcançar a Meta de lucro por cat~egoria*/
proc freq
data=ab.base_vendas_v2;
table bateu_meta
/list nocum;
run;

*Visualização da Tabela Lucro;
proc freq
data=ab.base_vendas_v2;
table Lucro
/list nocum;
run;

*gera um gráfico com a Coluna de lucro;
proc univariate
data=ab.base_vendas_v2;
var Lucro;
histogram;
run;

*Gráfico de linha;
proc sgplot
data=ab.base_vendas_v2;
vline Lucro; 
run;


/* gráfico de linha Com a Média de venda por Produto */
proc sgplot
data=ab.base_vendas_v2;
vline Valor_da_venda; 
yaxis grid minor minorcount=4 values=(0 to 70 by 5)  label="media de lucro por produto";
xaxis values=(0 to 200 by 10)  label="Vendas por Produto";
title "Média de Vendas por produto";
run;


*Gráfico com Barras;
proc sgplot
data=ab.base_vendas_v2;
vbar Valor_da_venda / fillattrs=(color=green); 
xaxis values=(0 to 800 by 20);

yaxis grid minor minorcount=4 values=(0 to 25 by 1);
run;



/* histograma com Vendas */
proc sgplot
data=ab.base_vendas_v2;
histogram Valor_da_venda; 
xaxis label="Vendas por Produto";
yaxis grid minor minorcount=4 label="Quantidade de Vendas";
title "Média de Vendas por produto";
run;


*Analise;
proc univariate data=VE.BASE_VENDAS_V2;
	ods select Histogram GoodnessOfFit ProbPlot;
	var Lucro;

	histogram Lucro / normal(mu=est sigma=est);
	inset median n / position=ne;
	probplot Lucro / normal(mu=est sigma=est);
run;


*Analise Univariada;
proc univariate
data=ve.base_vendas_v2;

var Valor_da_venda lucro ;
histogram;
run;
