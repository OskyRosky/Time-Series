#########################################################
#                                                       #
#   An�lisis por redes neuronales en series de tiempo   #
#                                                       #
#########################################################

#Librerias que necesitaremos

install.packages("forecast")
install.packages("caret")
install.packages("RSNNS")
install.packages("quantmod")
install.packages("nnet")

library(forecast)
library(caret)
library(RSNNS)
library(quantmod)
library(nnet)

######################
######################
#   Ejemplo 1: caret #
######################
######################

#####
# a #
#####

x=c(1774, 1706, 1288, 1276, 2350, 1821, 1712, 1654, 1680, 1451, 
  1275, 2140, 1747, 1749, 1770, 1797, 1485, 1299, 2330, 1822, 1627, 
  1847, 1797, 1452, 1328, 2363, 1998, 1864, 2088, 2084, 594, 884, 
  1968, 1858, 1640, 1823, 1938, 1490, 1312, 2312, 1937, 1617, 1643, 
  1468, 1381, 1276, 2228, 1756, 1465, 1716, 1601, 1340, 1192, 2231, 
  1768, 1623, 1444, 1575, 1375, 1267, 2475, 1630, 1505, 1810, 1601, 
  1123, 1324, 2245, 1844, 1613, 1710, 1546, 1290, 1366, 2427, 1783, 
  1588, 1505, 1398, 1226, 1321, 2299, 1047, 1735, 1633, 1508, 1323, 
  1317, 2323, 1826, 1615, 1750, 1572, 1273, 1365, 2373, 2074, 1809, 
  1889, 1521, 1314, 1512, 2462, 1836, 1750, 1808, 1585, 1387, 1428, 
  2176, 1732, 1752, 1665, 1425, 1028, 1194, 2159, 1840, 1684, 1711, 
  1653, 1360, 1422, 2328, 1798, 1723, 1827, 1499, 1289, 1476, 2219, 
  1824, 1606, 1627, 1459, 1324, 1354, 2150, 1728, 1743, 1697, 1511, 
  1285, 1426, 2076, 1792, 1519, 1478, 1191, 1122, 1241, 2105, 1818, 
  1599, 1663, 1319, 1219, 1452, 2091, 1771, 1710, 2000, 1518, 1479, 
  1586, 1848, 2113, 1648, 1542, 1220, 1299, 1452, 2290, 1944, 1701, 
  1709, 1462, 1312, 1365, 2326, 1971, 1709, 1700, 1687, 1493, 1523, 
  2382, 1938, 1658, 1713, 1525, 1413, 1363, 2349, 1923, 1726, 1862, 
  1686, 1534, 1280, 2233, 1733, 1520, 1537, 1569, 1367, 1129, 2024, 
  1645, 1510, 1469, 1533, 1281, 1212, 2099, 1769, 1684, 1842, 1654, 
  1369, 1353, 2415, 1948, 1841, 1928, 1790, 1547, 1465, 2260, 1895, 
  1700, 1838, 1614, 1528, 1268, 2192, 1705, 1494, 1697, 1588, 1324, 
  1193, 2049, 1672, 1801, 1487, 1319, 1289, 1302, 2316, 1945, 1771, 
  2027, 2053, 1639, 1372, 2198, 1692, 1546, 1809, 1787, 1360, 1182, 
  2157, 1690, 1494, 1731, 1633, 1299, 1291, 2164, 1667, 1535, 1822, 
  1813, 1510, 1396, 2308, 2110, 2128, 2316, 2249, 1789, 1886, 2463, 
  2257, 2212, 2608, 2284, 2034, 1996, 2686, 2459, 2340, 2383, 2507, 
  2304, 2740, 1869, 654, 1068, 1720, 1904, 1666, 1877, 2100, 504, 
  1482, 1686, 1707, 1306, 1417, 2135, 1787, 1675, 1934, 1931, 1456)
X=data.frame(x)
head(x)


length(x)
fitted(y)

y=auto.arima(X)
plot(forecast(y,h=30))
points(1:length(x),fitted(y),type="l",col="green")  #OJO puse 318 pero no es correcto!


summary(y)


####  ------> si usamos otro m�todo de redes neuronales

library(caret)
summary(x)
fit <- nnetar(x)              #------> no s� por qu� no debe ser un data.frame
plot(forecast(fit,h=60))
points(1:length(x),fitted(fit),type="l",col="green")

#####
# b #      #------> este no me sirve, no se porque no me abre la librer�a
#####      #------> https://www.otexts.org/fpp/9/3

library(caret)
data(GermanCredit)
creditlog  <- data.frame(score=credit$score,
                         log.savings=log(credit$savings+1),
                         log.income=log(credit$income+1),
                         log.address=log(credit$time.address+1),
                         log.employed=log(credit$time.employed+1),
                         fte=credit$fte, single=credit$single)

fit  <- avNNet(score ~ log.savings + log.income + log.address +
                 log.employed, data=creditlog, repeats=25, size=3, decay=0.1,
               linout=TRUE)

fit <- nnetar(sunspotarea)
plot(forecast(fit,h=20))

fit <- nnetar(sunspotarea,lambda=0)
plot(forecast(fit,h=20))

######################
######################
#   Ejemplo 2: RSNNS #
######################
######################

library(RSNNS)

#
# simulate an arima time series example of the length n
#
set.seed(10001)
n <- 100
ts.sim <- arima.sim(list(order = c(1,1,0), ar = 0.7), n = n-1)

#
# create an input data set for ts.sim
# sw = sliding-window size
#
# the last point of the time series will not be used
#   in the training phase, only in the prediction/validation phase
# 
sw <- 1
X <- lapply(sw:(n-2),
            function(ind){
              ts.sim[(ind-sw+1):ind]
            })
X <- do.call(rbind, X)
Y <- sapply(sw:(n-2),
            function(ind){
              ts.sim[ind+1]
            })

# used to validate prediction properties
# on the last point of the series
newX <- ts.sim[(n-sw):(n-1)]
newY <- ts.sim[n]

# build an elman network based on the input
model <- elman(X, Y,
               size = c(10, 10),
               learnFuncParams = c(0.001),
               maxit = 500,
               linOut = TRUE)

#
# plot the results
#
limits <- range(c(Y, model$fitted.values))

plot(Y, type = "l", col="red",
     ylab="Y", xlab="X")
lines(model$fitted.values, col = "green", type="l")

points(length(Y)+1, newY, col="red", pch=16)
points(length(Y)+1, predict(model, newdata=newX),
       pch="X", col="green")





