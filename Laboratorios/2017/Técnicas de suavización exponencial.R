###################################################
#                                                 #
#   Introducción a la series temporales           #
#                                                 #
###################################################

#Librerias que necesitaremos

install.packages("TTR")
install.packages("forecast")
install.packages("smooth")
install.packages("Mcomp")
installed.packages("stats")


library(TTR)
library(forecast)
library(smooth)
library(Mcomp)
library(stats)

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

logsouvenirtimeseries <- log(souvenirtimeseries)
plot.ts(logsouvenirtimeseries)

##########################################
# Descomposición de la serie de tiempo   #
##########################################

#################################
#   Pronosticando media movil   #
#################################

ma.souvenirtimeseries <-SMA(souvenirtimeseries, 4)
ma.souvenirtimeseries

plot(ma.souvenirtimeseries)

########################################
#   Pronosticando exponencial simple   #
########################################

Pron.souvenirtimeseries <- HoltWinters(souvenirtimeseries,beta=FALSE, gamma=FALSE)
Pron.souvenirtimeseries

plot(Pron.souvenirtimeseries)

names(Pron.souvenirtimeseries)

valores_predichos <- Pron.souvenirtimeseries$fitted
valores_predichos

forecast <- predict(Pron.souvenirtimeseries, n.ahead = 12, prediction.interval = T, level = 0.95)
plot(Pron.souvenirtimeseries, forecast)

########################################
#   Pronosticando exponencial doble   #
########################################

Pron.souvenirtimeseries.brown <- HoltWinters(souvenirtimeseries,alpha = TRUE ,beta=FALSE, gamma=FALSE)
Pron.souvenirtimeseries.brown

names(Pron.souvenirtimeseries.brown)

plot(Pron.souvenirtimeseries.brown)

forecast <- predict(Pron.souvenirtimeseries.brown, n.ahead = 12, prediction.interval = T, level = 0.95)
plot(Pron.souvenirtimeseries.brown, forecast)

##############################################
#   Pronosticando suavización con tendencia  #
##############################################

Pron.souvenirtimeseries.tendencia <- HoltWinters(souvenirtimeseries, gamma=FALSE)
Pron.souvenirtimeseries.tendencia

plot(Pron.souvenirtimeseries.tendencia)

forecast <- predict(Pron.souvenirtimeseries.tendencia, n.ahead = 12, prediction.interval = T, level = 0.95)
plot(Pron.souvenirtimeseries.tendencia, forecast)

##################################################
#   Pronosticando suavización con estacionalidad #
##################################################

###############################
# Holt Winters Aditivo        #
###############################


Pron.souvenirtimeseries.HWA <- HoltWinters(souvenirtimeseries,seasonal = c("additive"))
Pron.souvenirtimeseries.HWA

plot(Pron.souvenirtimeseries.HWA)

forecast <- predict(Pron.souvenirtimeseries.HWA, n.ahead = 12, prediction.interval = T, level = 0.95)
plot(Pron.souvenirtimeseries.HWA, forecast)

###############################
# Holt Winters Multiplicativo #
###############################

Pron.souvenirtimeseries.HWM <- HoltWinters(souvenirtimeseries,seasonal = c("multiplicative"))
Pron.souvenirtimeseries.HWM

plot(Pron.souvenirtimeseries.HWM)

forecast <- predict(Pron.souvenirtimeseries.HWM, n.ahead = 12, prediction.interval = T, level = 0.95)
plot(Pron.souvenirtimeseries.HWM, forecast)

##########################################################################
#             ¿Cómo se comprueba el mejor modelo?                        #
##########################################################################

#Tarea para la casa
#Determinen el mejor según los criterios de bondad y ajuste
# ¿Pueden utilizar la función "es()"?
#https://cran.r-project.org/web/packages/smooth/vignettes/es.html
