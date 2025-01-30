###################################################
#                                                 #
#   Introducción a la series temporales           #
#                                                 #
###################################################

#Librerias que necesitaremos

install.packages("TTR")
install.packages("forecast")

library(TTR)
library(forecast)

#########################################
# Conviritnedo en una serie de datos ts #
#########################################

#Lo primero será leer los datos en R y trazar la serie de tiempo. Se puede los datos en R usando la función scan (),
#que asume que los datos para puntos de tiempo sucesivos están en un archivo de texto simple con una columna.

#El archivo contiene datos sobre la edad de muerte de sucesivos reyes de Inglaterra, empezando por
#Guillermo el Conquistador

kings <- scan("http://robjhyndman.com/tsdldata/misc/kings.dat",skip=3)
#kings
head(kings)

#transformando en una serie de tiempo

#Una vez que haya leído los datos de la serie temporal en R, el siguiente paso es almacenar los datos
#en un objeto de serie temporal en R, de modo que pueda utilizar las muchas funciones de R para analizar
#datos de series temporales. Para almacenar los datos en un objeto de serie temporal, usamos la función ts () en R. 

kingstimeseries <- ts(kings)
kingstimeseries

#A veces, el conjunto de datos de series de tiempo que usted tiene puede haber sido recogido a intervalos
#regulares que fueron menos de un año, por ejemplo, mensual o trimestral. En este caso, puede especificar
#el número de veces que los datos fueron recolectados por año utilizando el parámetro 'frequency' en la
#función ts (). Para los datos de series temporales mensuales, se establece la frecuencia = 12, mientras
#que para los datos trimestrales de la serie temporal, se establece la frecuencia = 4.

#También puede especificar el primer año en que se recopilaron los datos y el primer intervalo de ese año
#utilizando el parámetro 'start' en la función ts (). Por ejemplo, si el primer punto de datos corresponde
#al segundo trimestre de 1986, se establecería start = c (1986,2).

#Colocando el arranque#

births <- scan("http://robjhyndman.com/tsdldata/data/nybirths.dat")
birthstimeseries <- ts(births, frequency=12, start=c(1946,1))
birthstimeseries


souvenir <- scan("http://robjhyndman.com/tsdldata/data/fancy.dat")
souvenirtimeseries <- ts(souvenir, frequency=12, start=c(1987,1))
souvenirtimeseries

######################################
# Graficando la serie de tiempo      #
######################################

#Una vez que haya leído una serie de tiempo en R, el siguiente paso suele ser hacer un gráfico de los
#datos de series de tiempo, que puede hacer con la función plot.ts () en R.

#Por ejemplo, para trazar la serie de tiempo de la edad de muerte de 42 reyes 
#sucesivos de Inglaterra:

plot.ts(kingstimeseries)

#Del mismo modo, para trazar la serie temporal del número de nacimientos por mes en la
#ciudad de Nueva York, escribimos:

plot.ts(birthstimeseries)

#Podemos ver a partir de esta serie de tiempo que parece haber variación estacional en el número de nacimientos
#por mes: hay un pico cada verano, y una depresión cada invierno. Una vez más, parece que esta serie temporal
#probablemente podría describirse usando un modelo aditivo, ya que las fluctuaciones estacionales son 
#aproximadamente constantes en tamaño con el tiempo y no parecen depender del nivel de la serie temporal,
#y las fluctuaciones aleatorias también parecen ser Aproximadamente de tamaño constante en el tiempo.

#Del mismo modo, para trazar la serie de tiempo de las ventas mensuales de la tienda de recuerdos en una 
#ciudad balnearia en Queensland, Australia, 

plot.ts(souvenirtimeseries)

#En este caso, parece que un modelo aditivo no es apropiado para describir esta serie temporal, ya que el
#tamaño de las fluctuaciones estacionales y las fluctuaciones aleatorias parecen aumentar con el nivel de
#las series temporales. Por lo tanto, es posible que necesitamos transformar las series temporales para 
#obtener una serie temporal transformada que se pueda describir utilizando un modelo aditivo.

#Graficando con transformación en los datos

logsouvenirtimeseries <- log(souvenirtimeseries)
plot.ts(logsouvenirtimeseries)

#Aquí podemos ver que el tamaño de las fluctuaciones estacionales y las fluctuaciones aleatorias en 
#las series de tiempo log-transformadas parecen ser aproximadamente constantes en el tiempo y no dependen
#del nivel de las series temporales. Por lo tanto, la serie de tiempo log-transformado puede describirse 
#probablemente utilizando un modelo aditivo.

##########################################
# Descomposición de la serie de tiempo   #
##########################################

#Descomponer una serie de tiempo significa separarla en sus componentes constituyentes, que suelen
#ser un componente de tendencia y un componente irregular, y si se trata de una serie temporal estacional,
#un componente estacional.

#########################
#  Sin estacionalidad   #
#########################

#Una serie temporal no estacional consiste en un componente de tendencia y un componente irregular. La
#descomposición de las series temporales implica tratar de separar las series de tiempo en estos componentes,
#es decir, estimar el componente de tendencia y el componente irregular.

#Para estimar el componente de tendencia de una serie temporal no estacional que se puede describir usando
#un modelo aditivo, es común usar un método de suavizado, como calcular el promedio móvil simple de las series
#temporales.

#La función SMA () en el paquete "TTR" R se puede utilizar para suavizar datos de series de tiempo utilizando
#una media móvil simple. Para utilizar esta función, primero debemos instalar el paquete "TTR" R. 
#Una vez que haya instalado el paquete "TTR" R, puede cargar el paquete "TTR" R escribiendo:

library("TTR")

#A continuación, puede utilizar la función "SMA ()" para suavizar los datos de series de tiempo. Para utilizar
#la función SMA (), debe especificar el orden (span) de la media móvil simple, utilizando el parámetro "n". 
#Por ejemplo, para calcular una media móvil simple de orden 5, establecemos n = 5 en la función SMA ().

#Por ejemplo, como se discutió anteriormente, la serie temporal de la edad de muerte de 42 reyes sucesivos
#de Inglaterra aparece no es estacional, y probablemente se puede describir utilizando un modelo aditivo, ya
#que las fluctuaciones aleatorias en los datos son más o menos constante en tamaño más hora:

#Por lo tanto, podemos tratar de estimar el componente de tendencia de esta serie de tiempo por suavizado
#utilizando un promedio móvil simple. Para suavizar la serie de tiempo usando una media móvil simple de orden 3,
#y trazar los datos de series temporales suavizadas.

kingstimeseriesSMA3 <- SMA(kingstimeseries,n=3)
plot.ts(kingstimeseriesSMA3)

#Todavía parece haber un montón de fluctuaciones aleatorias en la serie de tiempo suavizado utilizando una media
#móvil simple de orden 3. Así, para estimar el componente de tendencia con mayor precisión, es posible que desee
#tratar de suavizar los datos con una media móvil simple de un orden superior. Esto requiere un poco de prueba
#y error, para encontrar la cantidad correcta de suavizado. Por ejemplo, podemos intentar usar una media móvil
#simple de orden 8:

kingstimeseriesSMA8 <- SMA(kingstimeseries,n=8)
plot.ts(kingstimeseriesSMA8)

#Los datos suavizados con una media móvil simple de orden 8 dan una imagen más clara del componente de tendencia
#y podemos ver que la edad de muerte de los reyes ingleses parece haber disminuido de unos 55 años a unos
#38 años durante el reinado De los primeros 20 reyes, y después aumentó después de eso a cerca de 73 años para
#el final del reinado del 40.o rey en la serie de tiempo.

#######################
# Con estacionalidad  #
#######################

#Una serie temporal estacional consiste en un componente de tendencia, un componente
#estacional y un componente irregular. La descomposición de las series de tiempo significa
#separar las series temporales en estos tres componentes: es decir, estimar estos tres
#componentes.

#Para estimar el componente de tendencia y el componente estacional de una serie temporal
#estacional que se puede describir usando un modelo aditivo, podemos usar la función
#"descomponer ()" en R. Esta función estima la tendencia, los componentes estacionales
#e irregulares de una serie temporal Que se pueden describir utilizando un modelo aditivo.

#La función "decompose ()" devuelve un objeto de lista como su resultado, donde las
#estimaciones del componente estacional, el componente de tendencia y el componente
#irregular se almacenan en los elementos con nombre de esa lista de objetos, llamados
#"estacionales", "tendencia" y "aleatorios "Respectivamente.

#Por ejemplo, como se analizó anteriormente, la serie temporal del número de nacimientos
#mensuales en la ciudad de Nueva York es estacional, con un pico cada verano y cada 
#invierno, y probablemente se puede describir utilizando un modelo aditivo ya que las
#fluctuaciones estacionales y aleatorias parecen Ser aproximadamente de tamaño constante
#en el tiempo:

#Para estimar la tendencia, los componentes estacionales e irregulares de esta serie
#temporal

birthstimeseriescomponents <- decompose(birthstimeseries)

#Los valores estimados de la temporada, la tendencia y los componentes irregulares ahora
#se almacenan en variables birthstimeseriescomponents $ seasonal, 
#birthstimeseriescomponents $ trend y birthstimeseriescomponents $ random. 
#Por ejemplo, podemos imprimir los valores estimados del componente estacional escribiendo

birthstimeseriescomponents$seasonal

plot(birthstimeseriescomponents)

#La gráfica anterior muestra la serie temporal original (parte superior), el
#componente estimado de la tendencia (segundo de la parte superior), el componente
#estacional estimado (tercero de la parte superior) y el componente irregular
#estimado (parte inferior). Vemos que el componente de tendencia estimada muestra 
#una pequeña disminución de aproximadamente 24 en 1947 a aproximadamente 22 en 1948,
#seguido por un aumento constante desde entonces a aproximadamente 27 en 1959.

#########################
#   Ajuste estacional   # 
#########################

#Si usted tiene una serie temporal estacional que se puede describir usando un modelo aditivo, 
#puede ajustar estacionalmente la serie de tiempo estimando el componente estacional y 
#restando el componente estacional estimado de la serie temporal original. Podemos hacer esto 
#usando la estimación del componente estacional calculado por la función "descomponer ()".

#Por ejemplo, para ajustar temporalmente la serie temporal del número de nacimientos por mes
#en la ciudad de Nueva York, podemos estimar el componente estacional usando "descomponer ()" 
#y luego restar el componente estacional de la serie temporal original:

birthstimeseriescomponents <- decompose(birthstimeseries)
birthstimeseriesseasonallyadjusted <- birthstimeseries - birthstimeseriescomponents$seasonal

#Podemos entonces trazar la serie temporal ajustada estacionalmente utilizando la función "plot ()"

plot(birthstimeseriesseasonallyadjusted)

#Usted puede ver que la variación estacional se ha quitado de la serie de tiempo ajustada 
#estacionalmente. Las series de tiempo ajustadas estacionalmente ahora solo contienen
#el componente de tendencia y un componente irregular.

#######################
#   Pronosticando     #
#######################

#Si tiene una serie de tiempo que se puede describir utilizando un modelo aditivo con
#nivel constante y sin estacionalidad, puede utilizar el suavizado exponencial simple
#para hacer pronósticos a corto plazo.

#El método de suavizado exponencial simple proporciona una forma de estimar el nivel
#en el punto de tiempo actual. El suavizado es controlado por el parámetro alfa; Para
#la estimación del nivel en el punto de tiempo actual. El valor de alfa; Está entre 
#0 y 1. Los valores de alfa que son cercanos a 0 significan que se pone poco peso en
#las observaciones más recientes al hacer pronósticos de valores futuros.

rain <- scan("http://robjhyndman.com/tsdldata/hurst/precip1.dat",skip=1)
rainseries <- ts(rain,start=c(1813))
plot.ts(rainseries)

#Usted puede ver en la gráfica que hay un nivel aproximadamente constante (el
#promedio permanece constante en aproximadamente 25 pulgadas). Las
#fluctuaciones aleatorias en las series de tiempo parecen ser aproximadamente
#de tamaño constante en el tiempo, por lo que es probablemente apropiado 
#describir los datos utilizando un modelo aditivo. Así, podemos hacer
#pronósticos usando el suavizado exponencial simple.

#Para hacer pronósticos usando el suavizado exponencial simple en R, podemos 
#ajustar un modelo predictivo simple de suavizado exponencial usando la función
#"HoltWinters ()" en R. Para usar HoltWinters () para el suavizado exponencial 
#simple, necesitamos establecer los parámetros beta = FALSE y Gamma = FALSE en 
#la función HoltWinters () (los parámetros beta y gamma se usan para el suavizado
#exponencial de Holt o el suavizado exponencial de Holt-Winters, como se 
#describe a continuación).

#La función HoltWinters () devuelve una variable de lista, que contiene varios 
#elementos con nombre.

#Por ejemplo, para utilizar el suavizado exponencial simple para hacer pronósticos
#para la serie temporal de precipitaciones anuales en Londres:

rainseriesforecasts <- HoltWinters(rainseries, beta=FALSE, gamma=FALSE)
rainseriesforecasts

#La salida de HoltWinters () nos dice que el valor estimado del parámetro alfa
#es aproximadamente 0.024. Esto es muy cercano a cero, diciéndonos que las previsiones
#se basan en observaciones recientes y menos recientes (aunque se hace un poco 
#más de peso en las observaciones recientes).

#De forma predeterminada, HoltWinters () sólo hace previsiones para el mismo período
#cubierto por nuestra serie de tiempo original. En este caso, nuestra serie de 
#tiempo original incluyó la lluvia para Londres desde 1813-1912, por lo que las 
#previsiones son también para 1813-1912.

#En el ejemplo anterior, hemos almacenado la salida de la función HoltWinters () 
#en la variable de lista "rainseriesforecasts". Las previsiones hechas por 
#HoltWinters () se almacenan en un elemento con nombre de esta variable de lista 
#llamado "ajustado",

rainseriesforecasts$fitted

#Podemos trazar la serie de tiempo original con las predicciones escribiendo

plot(rainseriesforecasts)

#La gráfico muestra la serie de tiempo original en negro, y las previsiones
#como una línea roja. La serie temporal de pronósticos es mucho más suave
#que la serie temporal de los datos originales aquí.

#Como medida de la exactitud de los pronósticos, podemos calcular la
#suma de los errores al cuadrado para los errores de pronóstico de la
#muestra, es decir, los errores de previsión para el período de tiempo
#cubierto por nuestras series temporales originales. La suma de cuadrado
#de los errores se almacena en un elemento con nombre de la variable de
#lista "pluSeriesForecasts" llamado "SSE",

rainseriesforecasts$SSE

HoltWinters(rainseries, beta=FALSE, gamma=FALSE, l.start=23.56)

library("forecast")

#Cuando se utiliza la función forecast.HoltWinters (), como primer argumento 
#(entrada), se pasa el modelo predictivo que ya se ha instalado mediante 
#la función HoltWinters (). Por ejemplo, en el caso de las series de tiempo
#de lluvia, almacenamos el modelo predictivo realizado con HoltWinters () en
#la variable "previsiones de las lluvias". Especifique cuántos puntos de 
#tiempo adicionales desea realizar las previsiones utilizando el parámetro "h" 
#en forecast.HoltWinters (). Por ejemplo, para hacer una previsión de la lluvia 
#para los años 1814-1820 (8 años más) usando forecast.HoltWinters (),

rainseriesforecasts2 <- forecast.HoltWinters(rainseriesforecasts, h=8)
rainseriesforecasts2


#La función forecast.HoltWinters () le proporciona la previsión para un año,
#un intervalo de predicción del 80% para el pronóstico y un intervalo de
#predicción del 95% para el pronóstico. Por ejemplo, la precipitación 
#pronosticada para 1920 es de aproximadamente 24,68 pulgadas, con un 
#intervalo de predicción del 95% de (16,24, 33,11).

#Para trazar las predicciones hechas por forecast.HoltWinters (), 
#podemos usar la función "plot.forecast ()":

plot.forecast(rainseriesforecasts2)

