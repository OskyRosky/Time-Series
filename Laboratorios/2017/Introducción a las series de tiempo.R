###################################################
#                                                 #
#   Introducci�n a la series temporales           #
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

#Lo primero ser� leer los datos en R y trazar la serie de tiempo. Se puede los datos en R usando la funci�n scan (),
#que asume que los datos para puntos de tiempo sucesivos est�n en un archivo de texto simple con una columna.

#El archivo contiene datos sobre la edad de muerte de sucesivos reyes de Inglaterra, empezando por
#Guillermo el Conquistador

kings <- scan("http://robjhyndman.com/tsdldata/misc/kings.dat",skip=3)
#kings
head(kings)

#transformando en una serie de tiempo

#Una vez que haya le�do los datos de la serie temporal en R, el siguiente paso es almacenar los datos
#en un objeto de serie temporal en R, de modo que pueda utilizar las muchas funciones de R para analizar
#datos de series temporales. Para almacenar los datos en un objeto de serie temporal, usamos la funci�n ts () en R. 

kingstimeseries <- ts(kings)
kingstimeseries

#A veces, el conjunto de datos de series de tiempo que usted tiene puede haber sido recogido a intervalos
#regulares que fueron menos de un a�o, por ejemplo, mensual o trimestral. En este caso, puede especificar
#el n�mero de veces que los datos fueron recolectados por a�o utilizando el par�metro 'frequency' en la
#funci�n ts (). Para los datos de series temporales mensuales, se establece la frecuencia = 12, mientras
#que para los datos trimestrales de la serie temporal, se establece la frecuencia = 4.

#Tambi�n puede especificar el primer a�o en que se recopilaron los datos y el primer intervalo de ese a�o
#utilizando el par�metro 'start' en la funci�n ts (). Por ejemplo, si el primer punto de datos corresponde
#al segundo trimestre de 1986, se establecer�a start = c (1986,2).

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

#Una vez que haya le�do una serie de tiempo en R, el siguiente paso suele ser hacer un gr�fico de los
#datos de series de tiempo, que puede hacer con la funci�n plot.ts () en R.

#Por ejemplo, para trazar la serie de tiempo de la edad de muerte de 42 reyes 
#sucesivos de Inglaterra:

plot.ts(kingstimeseries)

#Del mismo modo, para trazar la serie temporal del n�mero de nacimientos por mes en la
#ciudad de Nueva York, escribimos:

plot.ts(birthstimeseries)

#Podemos ver a partir de esta serie de tiempo que parece haber variaci�n estacional en el n�mero de nacimientos
#por mes: hay un pico cada verano, y una depresi�n cada invierno. Una vez m�s, parece que esta serie temporal
#probablemente podr�a describirse usando un modelo aditivo, ya que las fluctuaciones estacionales son 
#aproximadamente constantes en tama�o con el tiempo y no parecen depender del nivel de la serie temporal,
#y las fluctuaciones aleatorias tambi�n parecen ser Aproximadamente de tama�o constante en el tiempo.

#Del mismo modo, para trazar la serie de tiempo de las ventas mensuales de la tienda de recuerdos en una 
#ciudad balnearia en Queensland, Australia, 

plot.ts(souvenirtimeseries)

#En este caso, parece que un modelo aditivo no es apropiado para describir esta serie temporal, ya que el
#tama�o de las fluctuaciones estacionales y las fluctuaciones aleatorias parecen aumentar con el nivel de
#las series temporales. Por lo tanto, es posible que necesitamos transformar las series temporales para 
#obtener una serie temporal transformada que se pueda describir utilizando un modelo aditivo.

#Graficando con transformaci�n en los datos

logsouvenirtimeseries <- log(souvenirtimeseries)
plot.ts(logsouvenirtimeseries)

#Aqu� podemos ver que el tama�o de las fluctuaciones estacionales y las fluctuaciones aleatorias en 
#las series de tiempo log-transformadas parecen ser aproximadamente constantes en el tiempo y no dependen
#del nivel de las series temporales. Por lo tanto, la serie de tiempo log-transformado puede describirse 
#probablemente utilizando un modelo aditivo.

##########################################
# Descomposici�n de la serie de tiempo   #
##########################################

#Descomponer una serie de tiempo significa separarla en sus componentes constituyentes, que suelen
#ser un componente de tendencia y un componente irregular, y si se trata de una serie temporal estacional,
#un componente estacional.

#########################
#  Sin estacionalidad   #
#########################

#Una serie temporal no estacional consiste en un componente de tendencia y un componente irregular. La
#descomposici�n de las series temporales implica tratar de separar las series de tiempo en estos componentes,
#es decir, estimar el componente de tendencia y el componente irregular.

#Para estimar el componente de tendencia de una serie temporal no estacional que se puede describir usando
#un modelo aditivo, es com�n usar un m�todo de suavizado, como calcular el promedio m�vil simple de las series
#temporales.

#La funci�n SMA () en el paquete "TTR" R se puede utilizar para suavizar datos de series de tiempo utilizando
#una media m�vil simple. Para utilizar esta funci�n, primero debemos instalar el paquete "TTR" R. 
#Una vez que haya instalado el paquete "TTR" R, puede cargar el paquete "TTR" R escribiendo:

library("TTR")

#A continuaci�n, puede utilizar la funci�n "SMA ()" para suavizar los datos de series de tiempo. Para utilizar
#la funci�n SMA (), debe especificar el orden (span) de la media m�vil simple, utilizando el par�metro "n". 
#Por ejemplo, para calcular una media m�vil simple de orden 5, establecemos n = 5 en la funci�n SMA ().

#Por ejemplo, como se discuti� anteriormente, la serie temporal de la edad de muerte de 42 reyes sucesivos
#de Inglaterra aparece no es estacional, y probablemente se puede describir utilizando un modelo aditivo, ya
#que las fluctuaciones aleatorias en los datos son m�s o menos constante en tama�o m�s hora:

#Por lo tanto, podemos tratar de estimar el componente de tendencia de esta serie de tiempo por suavizado
#utilizando un promedio m�vil simple. Para suavizar la serie de tiempo usando una media m�vil simple de orden 3,
#y trazar los datos de series temporales suavizadas.

kingstimeseriesSMA3 <- SMA(kingstimeseries,n=3)
plot.ts(kingstimeseriesSMA3)

#Todav�a parece haber un mont�n de fluctuaciones aleatorias en la serie de tiempo suavizado utilizando una media
#m�vil simple de orden 3. As�, para estimar el componente de tendencia con mayor precisi�n, es posible que desee
#tratar de suavizar los datos con una media m�vil simple de un orden superior. Esto requiere un poco de prueba
#y error, para encontrar la cantidad correcta de suavizado. Por ejemplo, podemos intentar usar una media m�vil
#simple de orden 8:

kingstimeseriesSMA8 <- SMA(kingstimeseries,n=8)
plot.ts(kingstimeseriesSMA8)

#Los datos suavizados con una media m�vil simple de orden 8 dan una imagen m�s clara del componente de tendencia
#y podemos ver que la edad de muerte de los reyes ingleses parece haber disminuido de unos 55 a�os a unos
#38 a�os durante el reinado De los primeros 20 reyes, y despu�s aument� despu�s de eso a cerca de 73 a�os para
#el final del reinado del 40.o rey en la serie de tiempo.

#######################
# Con estacionalidad  #
#######################

#Una serie temporal estacional consiste en un componente de tendencia, un componente
#estacional y un componente irregular. La descomposici�n de las series de tiempo significa
#separar las series temporales en estos tres componentes: es decir, estimar estos tres
#componentes.

#Para estimar el componente de tendencia y el componente estacional de una serie temporal
#estacional que se puede describir usando un modelo aditivo, podemos usar la funci�n
#"descomponer ()" en R. Esta funci�n estima la tendencia, los componentes estacionales
#e irregulares de una serie temporal Que se pueden describir utilizando un modelo aditivo.

#La funci�n "decompose ()" devuelve un objeto de lista como su resultado, donde las
#estimaciones del componente estacional, el componente de tendencia y el componente
#irregular se almacenan en los elementos con nombre de esa lista de objetos, llamados
#"estacionales", "tendencia" y "aleatorios "Respectivamente.

#Por ejemplo, como se analiz� anteriormente, la serie temporal del n�mero de nacimientos
#mensuales en la ciudad de Nueva York es estacional, con un pico cada verano y cada 
#invierno, y probablemente se puede describir utilizando un modelo aditivo ya que las
#fluctuaciones estacionales y aleatorias parecen Ser aproximadamente de tama�o constante
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

#La gr�fica anterior muestra la serie temporal original (parte superior), el
#componente estimado de la tendencia (segundo de la parte superior), el componente
#estacional estimado (tercero de la parte superior) y el componente irregular
#estimado (parte inferior). Vemos que el componente de tendencia estimada muestra 
#una peque�a disminuci�n de aproximadamente 24 en 1947 a aproximadamente 22 en 1948,
#seguido por un aumento constante desde entonces a aproximadamente 27 en 1959.

#########################
#   Ajuste estacional   # 
#########################

#Si usted tiene una serie temporal estacional que se puede describir usando un modelo aditivo, 
#puede ajustar estacionalmente la serie de tiempo estimando el componente estacional y 
#restando el componente estacional estimado de la serie temporal original. Podemos hacer esto 
#usando la estimaci�n del componente estacional calculado por la funci�n "descomponer ()".

#Por ejemplo, para ajustar temporalmente la serie temporal del n�mero de nacimientos por mes
#en la ciudad de Nueva York, podemos estimar el componente estacional usando "descomponer ()" 
#y luego restar el componente estacional de la serie temporal original:

birthstimeseriescomponents <- decompose(birthstimeseries)
birthstimeseriesseasonallyadjusted <- birthstimeseries - birthstimeseriescomponents$seasonal

#Podemos entonces trazar la serie temporal ajustada estacionalmente utilizando la funci�n "plot ()"

plot(birthstimeseriesseasonallyadjusted)

#Usted puede ver que la variaci�n estacional se ha quitado de la serie de tiempo ajustada 
#estacionalmente. Las series de tiempo ajustadas estacionalmente ahora solo contienen
#el componente de tendencia y un componente irregular.

#######################
#   Pronosticando     #
#######################

#Si tiene una serie de tiempo que se puede describir utilizando un modelo aditivo con
#nivel constante y sin estacionalidad, puede utilizar el suavizado exponencial simple
#para hacer pron�sticos a corto plazo.

#El m�todo de suavizado exponencial simple proporciona una forma de estimar el nivel
#en el punto de tiempo actual. El suavizado es controlado por el par�metro alfa; Para
#la estimaci�n del nivel en el punto de tiempo actual. El valor de alfa; Est� entre 
#0 y 1. Los valores de alfa que son cercanos a 0 significan que se pone poco peso en
#las observaciones m�s recientes al hacer pron�sticos de valores futuros.

rain <- scan("http://robjhyndman.com/tsdldata/hurst/precip1.dat",skip=1)
rainseries <- ts(rain,start=c(1813))
plot.ts(rainseries)

#Usted puede ver en la gr�fica que hay un nivel aproximadamente constante (el
#promedio permanece constante en aproximadamente 25 pulgadas). Las
#fluctuaciones aleatorias en las series de tiempo parecen ser aproximadamente
#de tama�o constante en el tiempo, por lo que es probablemente apropiado 
#describir los datos utilizando un modelo aditivo. As�, podemos hacer
#pron�sticos usando el suavizado exponencial simple.

#Para hacer pron�sticos usando el suavizado exponencial simple en R, podemos 
#ajustar un modelo predictivo simple de suavizado exponencial usando la funci�n
#"HoltWinters ()" en R. Para usar HoltWinters () para el suavizado exponencial 
#simple, necesitamos establecer los par�metros beta = FALSE y Gamma = FALSE en 
#la funci�n HoltWinters () (los par�metros beta y gamma se usan para el suavizado
#exponencial de Holt o el suavizado exponencial de Holt-Winters, como se 
#describe a continuaci�n).

#La funci�n HoltWinters () devuelve una variable de lista, que contiene varios 
#elementos con nombre.

#Por ejemplo, para utilizar el suavizado exponencial simple para hacer pron�sticos
#para la serie temporal de precipitaciones anuales en Londres:

rainseriesforecasts <- HoltWinters(rainseries, beta=FALSE, gamma=FALSE)
rainseriesforecasts

#La salida de HoltWinters () nos dice que el valor estimado del par�metro alfa
#es aproximadamente 0.024. Esto es muy cercano a cero, dici�ndonos que las previsiones
#se basan en observaciones recientes y menos recientes (aunque se hace un poco 
#m�s de peso en las observaciones recientes).

#De forma predeterminada, HoltWinters () s�lo hace previsiones para el mismo per�odo
#cubierto por nuestra serie de tiempo original. En este caso, nuestra serie de 
#tiempo original incluy� la lluvia para Londres desde 1813-1912, por lo que las 
#previsiones son tambi�n para 1813-1912.

#En el ejemplo anterior, hemos almacenado la salida de la funci�n HoltWinters () 
#en la variable de lista "rainseriesforecasts". Las previsiones hechas por 
#HoltWinters () se almacenan en un elemento con nombre de esta variable de lista 
#llamado "ajustado",

rainseriesforecasts$fitted

#Podemos trazar la serie de tiempo original con las predicciones escribiendo

plot(rainseriesforecasts)

#La gr�fico muestra la serie de tiempo original en negro, y las previsiones
#como una l�nea roja. La serie temporal de pron�sticos es mucho m�s suave
#que la serie temporal de los datos originales aqu�.

#Como medida de la exactitud de los pron�sticos, podemos calcular la
#suma de los errores al cuadrado para los errores de pron�stico de la
#muestra, es decir, los errores de previsi�n para el per�odo de tiempo
#cubierto por nuestras series temporales originales. La suma de cuadrado
#de los errores se almacena en un elemento con nombre de la variable de
#lista "pluSeriesForecasts" llamado "SSE",

rainseriesforecasts$SSE

HoltWinters(rainseries, beta=FALSE, gamma=FALSE, l.start=23.56)

library("forecast")

#Cuando se utiliza la funci�n forecast.HoltWinters (), como primer argumento 
#(entrada), se pasa el modelo predictivo que ya se ha instalado mediante 
#la funci�n HoltWinters (). Por ejemplo, en el caso de las series de tiempo
#de lluvia, almacenamos el modelo predictivo realizado con HoltWinters () en
#la variable "previsiones de las lluvias". Especifique cu�ntos puntos de 
#tiempo adicionales desea realizar las previsiones utilizando el par�metro "h" 
#en forecast.HoltWinters (). Por ejemplo, para hacer una previsi�n de la lluvia 
#para los a�os 1814-1820 (8 a�os m�s) usando forecast.HoltWinters (),

rainseriesforecasts2 <- forecast.HoltWinters(rainseriesforecasts, h=8)
rainseriesforecasts2


#La funci�n forecast.HoltWinters () le proporciona la previsi�n para un a�o,
#un intervalo de predicci�n del 80% para el pron�stico y un intervalo de
#predicci�n del 95% para el pron�stico. Por ejemplo, la precipitaci�n 
#pronosticada para 1920 es de aproximadamente 24,68 pulgadas, con un 
#intervalo de predicci�n del 95% de (16,24, 33,11).

#Para trazar las predicciones hechas por forecast.HoltWinters (), 
#podemos usar la funci�n "plot.forecast ()":

plot.forecast(rainseriesforecasts2)

