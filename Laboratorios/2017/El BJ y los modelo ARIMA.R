###################################################
#                                                 #
#      El  ARIMA con datos estacionales           #
#                                                 #
###################################################

#Librerias que necesitaremos

install.packages("TTR")
install.packages("forecast")
install.packages("ggplot22")
install.packages("tseries")
install.packages("normtest")
install.packages("stats")
install.packages("TSA")
install.packages("lmtest")

library(TTR)
library(forecast)
library(ggplot2)
library(tseries)
library(normtest)
library(stats)
library(TSA)
library(lmtest)

###################################################
#                                                 #
# Utilicemos de nuevo los datos de souvenirs      #
#                                                 #
###################################################

#########################################
# Conviritnedo en una serie de datos ts #
#########################################

souvenir <- scan("http://robjhyndman.com/tsdldata/data/fancy.dat")
souvenirtimeseries <- ts(souvenir, frequency=12, start=c(1987,1))
souvenirtimeseries

######################################
# Graficando la serie de tiempo      #
######################################

plot.ts(souvenirtimeseries)

#debemos trabajar con la serie en logaritmo

log.souvenirtimeseries=log(souvenirtimeseries)
plot(log.souvenirtimeseries)

# ¿La presente serie cumple con los requisitos de estacionaridad?
# ¿Cuáles eran esos requisitos?
# ¿Cuáles son los tipos de transformaciones que debemos hacer?
# ¿Qué se hace a nivel de la tendenci y la variancia?

#################################################
#   Análisis de las propiedades de la serie     #
#################################################

souv.desco <- decompose(souvenirtimeseries)
plot(souv.desco)
?decompose

#Vemos que a nivel del primero momento, no se cumple con la propiedad de estacionaridad
# Se debe realizar una transformación dado que se requiere que la serie sea estacionaria
# Recordar: media y auto-covariancia constantes en el tiempo.


#Test de Dickey-Fuller
adf.test(souvenirtimeseries, alternative = "stationary")   # ---> Para luego


#Analicemos un momento las auto-correlaciones totales y parciales 

auto.corr.total=Acf(souvenirtimeseries, main='Serie sin transformación')
auto.corr.total
auto.corr.parcial=Pacf(souvenirtimeseries, main='Serie sin transformación')
auto.corr.parcial

#Tanto la prueba de Advanced Dickey-Fuller como el auto-correlogrma total indican la necesidad de
# una diferenciación para la media.

####################################################
#  Transformando la serie --> serie estacionaria   #
####################################################

#Vamos a empezar con una diferenciación de orden 1

trans.souvenirtimeseries=diff(souvenirtimeseries,differences = 1)
plot(trans.souvenirtimeseries)

#A simple vista vemos que a nivel de la media, el problema de tendenci se soluciona.
# Sin embargo, vemos que la variancia no es constante, y requere también una transformación


log.souve=log(souvenirtimeseries)
plot(log.souve)

trans.tot=diff(log.souve,differences = 1)
plot(trans.tot)

#¿Qué podriamos decir del gráfico?
#Hay Algo más por transfrormar 
#¿Es la serie estacionaria?

#Veamos un poco los resultados

adf.test(trans.tot, alternative = "stationary")

adf.test(trans.tot, alternative = "stationary",k=12)

?adf.test

Acf(trans.tot, main='Serie con transformación')
Pacf(trans.tot, main='Serie con transformación')

#Al parecer, todo está bien. Por lo tanto, podemos pasar a la etapa de la estimación.


#######################
#                     #
#    Estimación       #
#                     #
#######################

#Acá podemos proceder de dos formas: manual o automática.

##########
# Manual #
##########

#Según el proceso de identificación, tenemos que ver tanto las 
#autocorrelaciones totales como las parciales

Acf(trans.tot, main='Serie con transformación')
Pacf(trans.tot, main='Serie con transformación')

#Lo cierto es que, no es facil de decir que es. En mi caso diría que es una AR(2), por la nulidad
# las ACP luego del orden 2. Luego, sabemos por el análisis anterior que deberíamos aplicar una 
#diferencia del orden 1. Por lo tanto estimaremos un ARIMA(2,1,0)

modelo.suver=arima(log.souvenirtimeseries,c(2,1,0))
modelo.suver

# Para ver poco más sobre el modelo, podemos utilizar la función "summary"

summary(modelo.suver)

##############
# Automática #
##############

modelo.auto.arima=auto.arima(log.souvenirtimeseries, seasonal=FALSE)
modelo.auto.arima

#Y vemos que el auto.arima también estima un AR(2)

#################################
#                               #
# Validación de los resultados  #
#                               #
#################################

#Tomamos por modelo el ARIMA(2,1,0)

modelo.suver=arima(log.souvenirtimeseries,c(2,1,0))
modelo.suver

#Ahora debemos verificar 

residuos=residuals(modelo.suver)
residuos
hist(residuos)

tsdisplay(residuos, lag.max=70, main='Evaluación de los residuos')


#Prueba de Jerca Bera

jarque.bera.test(residuals(modelo.suver))

#Prueba de Ljun-Box

Box.test(residuos, lag = 1, type = c("Ljung-Box"))
Box.test(residuos, lag = 12, type = c("Ljung-Box"))
Box.test(residuos, lag = 24, type = c("Ljung-Box"))

#Prueba de McLeod-Li 

plot(residuos,modelo.suver$fitted, main="Residuos contra valores predichos")

summary(McLeod.Li.test(y=residuos))
McLeod.Li.test(y=residuos)

#################################
#                               #
#    Pronóstico                 #
#                               #
#################################

pronostico1=forecast(modelo.suver,h=24)

plot(pronostico1)


# ¿Por qué el resultado es taaaaaan malo? 



#Ver el siguiente enlace
# https://www.datascience.com/blog/introduction-to-forecasting-with-arima-in-r-learn-data-science-tutorials
