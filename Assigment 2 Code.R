library(sna)
library(ergm)
library(igraph)
library(readxl)
library(intergraph)
library(statnet)

# Grotto Tommaso

setwd("C:/Users/39348/Downloads/Advanced Social Network Analysis/Assigment2")
list.files()

EIES_T2 <- read.csv("EIES_T2.csv", row.names=1)

EIES_T2F <- EIES_T2>2

EIES_T2F_n <- as.network(EIES_T2F)

gender_data <- read_excel("Data_Gender_1.xlsx")

EIES_T2F_n_igraph <- asIgraph(EIES_T2F_n)

network.vertex.names(EIES_T2F_n)

V(EIES_T2F_n_igraph)$name <- network.vertex.names(EIES_T2F_n)

V(EIES_T2F_n_igraph)$name

gender_ordered <- gender_data$Gender[match(V(EIES_T2F_n_igraph)$name, gender_data$ID)]

EIES_T2F_n_igraph <- set_vertex_attr(EIES_T2F_n_igraph, "Gender", value = gender_ordered)

V(EIES_T2F_n_igraph)$Gender

EIES_T2F_n_igraph

EIES_T2F_n <- asNetwork(EIES_T2F_n_igraph)

EIES_Model1 <- ergm(
  EIES_T2F_n ~ edges + mutual 
  + gwidegree(decay = 0.3, fixed = TRUE) 
  + gwodegree(decay = 0.3, fixed = TRUE) 
  + dgwesp(type = "OTP", decay = 0.5, fixed = TRUE) 
  + dgwesp(type = "ITP", decay = 0.5, fixed = TRUE),
  control = control.ergm(seed = 102, MCMC.runtime.traceplot = TRUE),
  verbose = TRUE
)

EIES_Model2 <- ergm(
  EIES_T2F_n ~ edges + mutual 
  + nodeicov("Gender") + nodeocov("Gender") 
  + nodematch("Gender"),
  control = control.ergm(seed = 102, MCMC.runtime.traceplot = TRUE),
  verbose = TRUE
)

EIES_Model3 <- ergm(
  EIES_T2F_n ~ edges + mutual 
  + gwidegree(decay = 0.3, fixed = TRUE) 
  + gwodegree(decay = 0.3, fixed = TRUE) 
  + dgwesp(type = "OTP", decay = 0.5, fixed = TRUE) 
  + dgwesp(type = "ITP", decay = 0.5, fixed = TRUE) 
  + nodeicov("Gender") + nodeocov("Gender") 
  + nodematch("Gender"),
  control = control.ergm(seed = 102, MCMC.runtime.traceplot = TRUE),
  verbose = TRUE
)

summary(EIES_Model1)
summary(EIES_Model2)
summary(EIES_Model3)

mcmc.diagnostics(EIES_Model1)
mcmc.diagnostics(EIES_Model2)
mcmc.diagnostics(EIES_Model3)

gof.choices <- control.gof.ergm(nsim = 2000)

EIES_Model3sim2000 <- gof(
  EIES_Model3,
  GOF = ~model + idegree + odegree + distance + triadcensus,
  control = gof.choices
)

# Summary of GOF
EIES_Model3sim2000$summary.model

par(mfrow = c(1, 1))
par(mar=c(3,3,3,3))

hist(EIES_Model3sim2000$sim.model[,1]+.01, nclass=20, main = paste("Histogram of edges"), probability = T, xlab = NA)
abline(v = EIES_Model3sim2000$summary.model[1,1], col = "red", lwd = 3)
abline(v = EIES_Model3sim2000$summary.model[1,3], col = "blue", lwd = 3, lty=2)

hist(EIES_Model3sim2000$sim.model[,2]+.01, nclass=25, main = paste("Histogram of mutual"), probability = T, xlab = NA)
abline(v = EIES_Model3sim2000$summary.model[2,1], col = "red", lwd = 3)
abline(v = EIES_Model3sim2000$summary.model[2,3], col = "blue", lwd = 3, lty=2)

hist(EIES_Model3sim2000$sim.model[,3]+.01, nclass=30, main = paste("Histogram of gwideg"), probability = T, xlab = NA)
abline(v = EIES_Model3sim2000$summary.model[3,1], col = "red", lwd = 3)
abline(v = EIES_Model3sim2000$summary.model[3,3], col = "blue", lwd = 3, lty=2)

hist(EIES_Model3sim2000$sim.model[,4]+.01, nclass=30, main = paste("Histogram of gwodeg"), probability = T, xlab = NA)
abline(v = EIES_Model3sim2000$summary.model[4,1], col = "red", lwd = 3)
abline(v = EIES_Model3sim2000$summary.model[4,3], col = "blue", lwd = 3, lty=2)

hist(EIES_Model3sim2000$sim.model[,5]+.01, nclass=30, main = paste("Histogram of gwesp.OTP"), probability = T, xlab = NA)
abline(v = EIES_Model3sim2000$summary.model[5,1], col = "red", lwd = 3)
abline(v = EIES_Model3sim2000$summary.model[5,3], col = "blue", lwd = 3, lty=2)

hist(EIES_Model3sim2000$sim.model[,6]+.01, nclass=30, main = paste("Histogram of gwesp.ITP"), probability = T, xlab = NA)
abline(v = EIES_Model3sim2000$summary.model[6,1], col = "red", lwd = 3)
abline(v = EIES_Model3sim2000$summary.model[6,3], col = "blue", lwd = 3, lty=2)

hist(EIES_Model3sim2000$sim.model[,7]+.01, nclass=30, main = paste("Histogram of nodeicov.Gender"), probability = T, xlab = NA)
abline(v = EIES_Model3sim2000$summary.model[7,1], col = "red", lwd = 3)
abline(v = EIES_Model3sim2000$summary.model[7,3], col = "blue", lwd = 3, lty=2)

hist(EIES_Model3sim2000$sim.model[,8]+.01, nclass=30, main = paste("Histogram of nodeocov.Gender"), probability = T, xlab = NA)
abline(v = EIES_Model3sim2000$summary.model[8,1], col = "red", lwd = 3)
abline(v = EIES_Model3sim2000$summary.model[8,3], col = "blue", lwd = 3, lty=2)

hist(EIES_Model3sim2000$sim.model[,9]+.01, nclass=30, main = paste("Histogram of nodematch.Gender"), probability = T, xlab = NA)
abline(v = EIES_Model3sim2000$summary.model[9,1], col = "red", lwd = 3)
abline(v = EIES_Model3sim2000$summary.model[9,3], col = "blue", lwd = 3, lty=2)

plot(EIES_Model3sim2000$sim.model[,1], type="l", main = paste("Trace plot for edges"), ylab="", xlab="")
plot(EIES_Model3sim2000$sim.model[,2], type="l", main = paste("Trace plot for mutual"), ylab="", xlab="")
plot(EIES_Model3sim2000$sim.model[,3], type="l", main = paste("Trace plot for gwideg"), ylab="", xlab="")
plot(EIES_Model3sim2000$sim.model[,4], type="l", main = paste("Trace plot for gwodeg"), ylab="", xlab="")
plot(EIES_Model3sim2000$sim.model[,5], type="l", main = paste("Trace plot for gwesp.OTP"), ylab="", xlab="")
plot(EIES_Model3sim2000$sim.model[,6], type="l", main = paste("Trace plot for gwesp.ITP"), ylab="", xlab="")
plot(EIES_Model3sim2000$sim.model[,7], type="l", main = paste("Trace plot for nodeicov.Gender"), ylab="", xlab="")
plot(EIES_Model3sim2000$sim.model[,8], type="l", main = paste("Trace plot for nodeocov.Gender"), ylab="", xlab="")
plot(EIES_Model3sim2000$sim.model[,9], type="l", main = paste("Trace plot for nodematch.Gender"), ylab="", xlab="")

plot(EIES_Model3sim2000)

boxplot(EIES_Model3sim2000$sim.odeg[,1:11], main = "Out-degree Boxplots")

EIES_Model3sim2000$obs.odeg
for (k in 1:16)
{
  hist(EIES_Model3sim2000$sim.triadcensus[,k], main=colnames(EIES_Model3sim2000$sim.triadcensus)[k])
  abline(v = EIES_Model3sim2000$obs.triadcensus[k], col = "blue", lwd = 3, lty=2)
}
EIES_Model3sim2000$obs.triadcensus
