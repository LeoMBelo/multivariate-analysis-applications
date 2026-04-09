dados = read.table('data_bateria.txt', header = T)
dados
dim(dados)
col_names = c('Charge rate', 'Discharge rate', 'Depht of discharge', 'Temperature', 'Ends of charge voltage')
name_resp = c('Cycles of failure')
nomes = c('Charge rate', 'Discharge rate', 'Depht of discharge', 'Temperature', 'Ends of charge voltage','Cycles of failure')

# separando as variaveis resposta e preditoras
Z = dados[1:20,1:5]
Y = dados[1:20,6]
Z_name = dados[1:20,1:5]
colnames(Z_name) = col_names

dados_nomes = dados
colnames(dados_nomes) = nomes
summary(dados_nomes)

#Explorando os dados
hist(dados$z1, main = 'Hist Charge rate',ylab = 'frequencia', xlab = 'Charge rate', col = 'blue')


#Graficos
pairs(dados_nomes)
boxplot(Z_name[1:20,3:4], col = 'light blue')
boxplot(Z_name[1:20,1:2], col = 'light blue')
boxplot(Z_name[1:20,5], xlab = 'Ends of charge voltage',col = 'light blue')

#Correleçao
library("corrplot")
corrQuant <- cor(dados, use = "complete.obs")
corrplot(corrQuant, method = "color", type = "upper", tl.pos = "lt")

#Medidas estatisticas
summary(dados)
S = var(Z)
S
R = cor(dados)
round(R, digits = 3) # Boa correlaçao entre Z4 e Y.

R_dados = cor(Z)
R_dados
# Decomposiçao espectral
spec = eigen(S)
spec$values

dec_R = eigen(R)
dec_R$values

dec_Rd = eigen(R_dados)
round(dec_Rd$values, digits = 3)
plot(c(1,2,3,4,5), dec_Rd$values, xlab = 'nº autovalores', ylab = 'autovalores')
(dec_Rd$values[1] + dec_Rd$values[2]+dec_Rd$values[3]+dec_Rd$values[4])/5
#############Tarefa 1: Criando Modelo regressao para ln(Y)

lny = log(Y)
baseln = dados
baseln[1:20,6] = lny
baseln
modelo1 = lm(y ~ .-1, data = baseln)
modelo1

summary(modelo1)
#grafico modelo 1
plot(y ~ z4, data = baseln)
abline(modelo1)

#modelo 1
summary(modelo)
#histograma dos residuos. Esper-se que estejam proximos de uma distribuiçao normal.
hist(modelo1$residuals, xlab = 'residuos', main = 'Histograma resíduos modelo 1') #modelo nao ficou bom

#Coeficiente de determinaçao
summary(modelo1)$r.squared # 66% de ln(Y) é explicada usando essas 5 variaveis 
summary(modelo1)$adj.r.squared 

#Teste de shapiro-wilk
shapiro.test(modelo1$residuals)

####################### modelo 2 ajustado
ajuste = step(modelo1,direction = 'both', scale = 1.07)
resumo = summary(ajuste)
names(resumo)



##MODELO 2
step(modelo1,direction = 'both', scale = 1.07^2)
#help(step)
modelo2 = lm(formula = y ~ z2 + z4, data = baseln)
summary(modelo2)
hist(modelo2$residuals, xlab = 'residuos', main = 'Histograma resíduos modelo 2')
shapiro.test(modelo2$residuals)

# Teste normalidade
par(mfrow = c(2,2))
plot(modelo2, which = c(1:4), pch = 20)

##MODELO 3
#step(modelo1,direction = 'both', scale = 1.07^2)
#help(step)
modelo3 = lm(formula = y ~ z2 + z4-1, data = baseln)
summary(modelo3)
hist(modelo3$residuals, xlab = 'residuos', main = 'Histograma resíduos modelo 3')
shapiro.test(modelo3$residuals)

# Teste normalidade
par(mfrow = c(2,2))
plot(modelo3, which = c(1:4), pch = 20)

########## c) INTERVALO DE CONFIANÇA
n = 20
r = 2
alpha = 0.05
#Criando matriz com z2 e z4
aux_m = as.matrix(baseln)
var_modelo3 = matrix(0,20,2)
var_modelo3[1:20,1] = aux_m[1:20,2]
var_modelo3[1:20,2] = aux_m[1:20,4]
var_modelo3
#matriz de covariancia estimada para elipsoide de confiança
er = modelo3$residuals
s2 = (t(er)%*%(er))/(n-r-1)
s2
inv_ztz=solve(t(var_modelo3)%*%var_modelo3)
inv_ztz
cov_estimada = as.numeric(s2)*inv_ztz
cov_estimada[1,1]
#intervalo de confiança
b1 = sqrt(cov_estimada[1,1]*qt(1-alpha/2,n-r-1))
b2 = sqrt(cov_estimada[2,2]*qt(1-alpha/2,n-r-1))


qmres2=sum(modelo3$residuals^2)/(n-r)
s2=sqrt(qmres2)
y02=t(z0)%*%modelo3$coefficients
erro_ic2=qt(1-alpha/2,n-r)*s2*sqrt(aux) # margem de erro do Intervalo de confiança
erro_ip2=qt(1-alpha/2,n-r)*s2*sqrt(1+aux) # margem de erro do intervalo de previsão
y02
erro_ic2
erro_ip2

########################################################################################
## Dados para traçar a elipse (carregar pacote ellipse)
########################################################################################
library(ellipse)
z02 = modelo3$coefficients[1]
z04 = modelo3$coefficients[2]
centro=c(z02,z04)
plot(ellipse(cov_estimada,centre=centro,level=0.95,npoints=200),xlim=c(-0.3,0.5),xlab="z2",ylim=c(0,0.4),ylab="z4",main="Região de 95% de confiança para os parâmetros")
points(z02,z04,pch=16,col="red")
abline(v=z02-b1,lty=2,col="red")
abline(v=z02 + b1,lty=2,col="red")
abline(h=z04 + b2,lty=2,col="red")
abline(h=z04 - b2,lty=2,col="red")



################################ PCA
library(MASS)
library(factoextra)
#install.packages('factoextra')

modelo4 = prcomp(~.,data = Z, scale = TRUE)
resultado = summary(modelo4)
resultado
resultado$rotation #autovetores
modelo4$rotation[1:5,1]
modelo4
#get_eig(modelo4)
fviz_screeplot(modelo4, type = 'lines', addlabels = TRUE, ylim = c(0,40), main = 'Contribuição ACP')

#Definindo componentes que mais contribuem
var = get_pca_var(modelo4)
var
var$coord
var$contrib
corrplot(var$contrib, is.corr =FALSE)
fviz_contrib(modelo4, choice = "var", axes = 1, top = 10)
fviz_contrib(modelo4, choice = "var", axes = 1:2, top = 10)
####################Componentes
##Padronizando dados
dados_padronizados = scale(baseln)
dados_padronizados
dados_padronizados[1,1:5]
modelo4
modelo4$rotation[1:5,1]
u = modelo4$rotation[1:5,1]%*%dados_padronizados[1,1:5]
u
#Criando matriz com as componentes principais
Z_new = matrix(0,20,5)
#Primeira coluna
for (i in 1:20) 
  {u = modelo4$rotation[1:5,1]%*%dados_padronizados[i,1:5]
  Z_new[i,1] = u
}
#segunda coluna
for (i in 1:20) 
{u = modelo4$rotation[1:5,2]%*%dados_padronizados[i,1:5]
Z_new[i,2] = u
}
#terceira coluna
for (i in 1:20) 
{u = modelo4$rotation[1:5,3]%*%dados_padronizados[i,1:5]
Z_new[i,3] = u
}
#quarta coluna
for (i in 1:20) 
{u = modelo4$rotation[1:5,4]%*%dados_padronizados[i,1:5]
Z_new[i,4] = u
}

#for (j in 1:5)
#{ for (i in 1:20)
#  {u = modelo4$rotation[1:5,j]%*%dados_padronizados[i,1:5]
#  Z_new[i,j] = u}
#  }
Z_new[1:20,5] = dados_padronizados[1:20,6]
col_names = c('PC1_pd', 'PC2_pd', 'PC3_pd', 'PC4_pd', 'lny_pd')
colnames(Z_new) = col_names
Z_new
#Modelo 5
modelo4 = lm(lny_pd ~ .-1, data = data.frame(Z_new))
modelo4
summary(modelo4)
