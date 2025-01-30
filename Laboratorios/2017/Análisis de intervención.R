###################################################
#                                                 #
#         El análisis de invertención             #
#                                                 #
###################################################

#Librerias que necesitaremos

install.packages("ggplot2")
install.packages("forecast")
install.packages("astsa")
install.packages("lmtest")
install.packages("fUnitRoots")
install.packages("FitARMA")
install.packages("strucchange")
install.packages("reshape")
install.packages("Rmisc")
install.packages("fBasics")


library(ggplot2)
library(forecast)
library(astsa)
library(lmtest)
library(fUnitRoots)
library(FitARMA)
library(strucchange)
library(reshape)
library(Rmisc)
library(fBasics)

###################################
#   Estadísticas exploratorias    #
###################################

url <- "https://www.openintro.org/stat/data/arbuthnot.csv"
abhutondot <- read.csv(url, header=TRUE)
nrow(abhutondot)

head(abhutondot)

abhutondot_rs <- melt(abhutondot, id = c("year"))
head(abhutondot_rs)
tail(abhutondot_rs)

#Gráfica de la serie

ggplot(data = abhutondot_rs, aes(x = year)) + geom_line(aes(y = value, colour = variable)) +
  scale_colour_manual(values = c("blue", "red"))


#######################################
#   Definiendo la serie como una TS   #
#######################################

excess_frac <- (abhutondot$boys - abhutondot$girls)/abhutondot$girls
excess_ts <- ts(excess_frac, frequency = 1, start = abhutondot$year[1])
plot(excess_ts)

basicStats(excess_frac)


#######################################
#        Auto-correlograma            #
#######################################

par(mfrow=c(1,2))
acf(excess_ts)
pacf(excess_ts)

summary(lm(excess_ts ~ 1))

#######################################
#      Cambios estructurales          #
#######################################

(break_point <- breakpoints(excess_ts ~ 1))

par(mfrow=c(1,1))
plot(break_point)

summary(break_point)

#El valor mínimo de BIC se alcanza cuando m = 1, por lo que solo se determina
#un punto de ruptura correspondiente al año 1670. Tracemos la serie temporal
#original contra su ruptura estructural y su intervalo de confianza.


plot(excess_ts)
lines(fitted(break_point, breaks = 1), col = 4)
lines(confint(break_point, breaks = 1))


fitted(break_point)[1]

###################################
#  Estimación de 6 modelos ARIMA  #
###################################

Se van a estimar los siguientes 6 modelos:
  
# 1. non seasonal (1,1,1), as determined by auto.arima() within forecast package
# 2. seasonal (1,0,0)(0,0,1)[10]
# 3. seasonal (1,0,0)(1,0,0)[10]
# 4. seasonal (0,0,0)(0,0,1)[10] with level shift regressor as intervention variable
# 5. seasonal (1,0,0)(0,0,1)[10] with level shift regressor as intervention variable
# 6. non seasonal (1,0,0) with level shift regressor as intervention variable  


###################################
#  ARIMA 1. non seasonal (1,1,1)  #
###################################

(model_1 <- auto.arima(excess_ts, stepwise = FALSE, trace = TRUE))
summary(model_1)

#######################################
#  ARIMA 2.  seasonal (1,0,0)(0,0,1)  #
#######################################
  
model_2 <- Arima(excess_ts, order = c(1,0,0), seasonal = list(order = c(0,0,1), period = 10), include.mean = TRUE)
summary(model_2)

#######################################
#  ARIMA 3. seasonal (1,0,0)(1,0,0)   #
#######################################

model_3 <- Arima(excess_ts, order = c(1,0,0), seasonal = list(order = c(1,0,0), period = 10), include.mean = TRUE)
summary(model_3)

########################################################
#  ARIMA 4.  seasonal (0,0,0)(0,0,1)                   #
# with level shift regressor as intervention variable  #
########################################################

#OJO!  así es como definims la intervención

level <- c(rep(0, break_point$breakpoints), rep(1, length(excess_ts) - break_point$breakpoints))

model_4 <- Arima(excess_ts, order = c(0,0,0), seasonal = list(order = c(0,0,1), period = 10), xreg = level, include.mean = TRUE)
summary(model_4)

########################################################
#  ARIMA 5.  seasonal (1,0,0)(0,0,1)                   #
# with level shift regressor as intervention variable  #
########################################################

model_5 <- Arima(excess_ts, order = c(1,0,0), seasonal = list(order = c(0,0,1), period=10),  xreg = level, include.mean = TRUE)
summary(model_5)

########################################################
#  6. non seasonal (1,0,0)                             #
# with level shift regressor as intervention variable  #
########################################################

model_6 <- Arima(excess_ts, order = c(1,0,0), xreg = level, include.mean = TRUE)
summary(model_6)


##################################################
#    Análisis de los residuos de cada uno de     #
#           los modelos estimados                #
##################################################

#El modelo n. ° 5 se retiró del análisis, por lo tanto,sus residuos no se verificarán.
 
#############
#  Modelo 1 #
#############

checkresiduals(model_1)
LjungBoxTest(residuals(model_1), k = 2, lag.max = 20)
sarima(excess_ts, p = 1, d = 1, q = 1)

#############
#  Modelo 2 #
#############

checkresiduals(model_2)
LjungBoxTest(residuals(model_2), k = 2, lag.max = 20)
sarima(excess_ts, p = 1, d = 0, q = 0, P = 0, D = 0, Q = 1, S = 10)

#############
#  Modelo 3 #
#############

checkresiduals(model_3)
LjungBoxTest(residuals(model_3), k = 2, lag.max = 20)
sarima(excess_ts, p = 1, d = 0, q = 0, P = 1, D = 0, Q = 0, S = 10)

#############
#  Modelo 4 #
#############

checkresiduals(model_4)
LjungBoxTest(residuals(model_4), k = 1, lag.max = 20)
sarima(excess_ts, p = 0, d = 0, q = 0, P = 0, D = 0, Q = 1, S = 10, xreg = level)


#############
#  Modelo 6 #
#############

checkresiduals(model_6)
LjungBoxTest(residuals(model_6), k = 1, lag.max = 20)
sarima(excess_ts, p = 1, d = 0, q = 0, xreg = level)

##################################################
#        Comparación de modelos                  #
#                                                #
##################################################

# Finalmente, es hora de recopilar las métricas generales de AIC, AICc y BIC de nuestros
# cinco modelos candidatos (recuerde que el modelo n. ° 5 ha sido excluido del enjuiciamiento
# del análisis) y elegir el mejor modelo o el modelo final.

df <- data.frame(col_1_res = c(model_1$aic, model_2$aic, model_3$aic, model_4$aic, model_6$aic),
                 col_2_res = c(model_1$aicc, model_2$aicc, model_3$aicc, model_4$aicc, model_6$aicc),
                 col_3_res = c(model_1$bic, model_2$bic, model_3$bic, model_4$bic, model_6$bic))

colnames(df) <- c("AIC", "AICc", "BIC")
rownames(df) <- c("ARIMA(1,1,1)", 
                  "ARIMA(1,0,0)(0,0,1)[10]", 
                  "ARIMA(1,0,0)(1,0,0)[10]", 
                  "ARIMA(0,0,0)(0,0,1)[10] with level shift", 
                  "ARIMA(1,0,0) with level shift")
df

#El modelo que proporciona las mejores métricas AIC, AICc y BIC al mismo tiempo
#es el modelo n. ° 4, ARIMA (0,0,0) (0,0,1) con cambio de nivel.

##################################################
#                 Pronóstico                     #
#                                                #
##################################################


h_fut <- 20
plot(forecast(model_4, h = h_fut, xreg = rep(1, h_fut)))


##################################################
#      ¿Y si metemos más intervenciones?         #
#                                                #
##################################################


abhutondot.ts <- ts(abhutondot$boys + abhutondot$girls, frequency = 1 , start = abhutondot$year[1])
plot(abhutondot.ts)


summary(lm(abhutondot.ts ~ 1))

#######################################
#      Cambios estructurales          #
#######################################

(break_point <- breakpoints(abhutondot.ts ~ 1))
plot(break_point)
summary(break_point)

#El valor mínimo de BIC se alcanza con m = 3. Tracemos la serie temporal original
#contra sus rupturas estructurales y sus intervalos de confianza.

plot(abhutondot.ts)
fitted.ts <- fitted(break_point, breaks = 3)
lines(fitted.ts, col = 4)
lines(confint(break_point, breaks = 3))

#Los niveles ajustados y las fechas de los puntos de interrupción son los siguientes.

unique(as.integer(fitted.ts))
breakdates(break_point, breaks = 3)

fitted.ts <- fitted(break_point, breaks = 3)
autoplot(fitted.ts)

###############################################
#        Estimación del modelo ARIMA          #
###############################################

abhutondot_xreg <- Arima(abhutondot.ts, order = c(0,1,1), xreg = fitted.ts, include.mean = TRUE)
summary(abhutondot_xreg)


###############################################
#        Análisis de los residuos             #
###############################################

checkresiduals(abhutondot_xreg)
LjungBoxTest(residuals(abhutondot_xreg), k=1, lag.max=20)
sarima(abhutondot.ts, p=0, d=1, q=1, xreg = fitted.ts)

#Los residuos son ruido blanco.

#Tener estacionalidad puntual y cambios de nivel fueron aspectos importantes 
#en nuestro análisis de modelos ARIMA. El componente estacional permitió definir
#modelos con residuos de ruido blanco. El análisis de roturas estructurales permitió
#definir modelos con una mejor métrica AIC introduciendo como regresor los cambios de 
#nivel identificados. También tuvimos la oportunidad de pasar por algunos comentarios
#históricos de la historia de Inglaterra y conocer la proporción de sexos en los estudios
#de nacimiento.

