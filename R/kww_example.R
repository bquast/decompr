# KWW Example:
if(FALSE) {
library(decompr)

# load example data
data(leather)

# create intermediate object (class decompr)
x <- load_tables_vectors(leather)

list2env(x, environment())

# Creating identifiers for block matrices
s1 <- r1 <- t1 <- 1:3
s2 <- r2 <- t2 <- 4:6
s3 <- r3 <- t3 <- 7:9


# T1
t(Vc[s1]) %*% (B[s1, s1] %*% Y[s1, 2] + B[s1, s1] %*% Y[s1, 3])
# T2
t(Vc[s1]) %*% (B[s1, r2] %*% Y[r2, 2] + B[s1, s3] %*% Y[r3, 3])
# T3
t(Vc[s1]) %*% (B[s1, r2] %*% Y[r2, 3] + B[s1, r3] %*% Y[r3, 2])
# T4
t(Vc[s1]) %*% (B[s1, r2] %*% Y[r2, 1] + B[s1, r3] %*% Y[r3, 1])
# T5
t(Vc[s1]) %*% (B[s1, r2] %*% Am[r2, s1] %*% L[s1, s1] %*% Y[s1, 1] +
               B[s1, r3] %*% Am[r3, s1] %*% L[s1, s1] %*% Y[s1, 1])
# T6
t(Vc[s1]) %*% (B[s1, r2] %*% Am[r2, s1] %*% L[s1, s1] %*% E[s1] +
               B[s1, r3] %*% Am[r3, s1] %*% L[s1, s1] %*% E[s1])
# T7
t(Vc[t2]) %*% B[t2, s1] %*% Y[s1, 2] + t(Vc[t3]) %*% B[t3, s1] %*% Y[s1, 2] +
t(Vc[t2]) %*% B[t2, s1] %*% Y[s1, 3] + t(Vc[t3]) %*% B[t3, s1] %*% Y[s1, 3]
# T8
t(Vc[t2]) %*% (B[t2, s1] %*% Am[s1, r2] %*% L[r2, r2] %*% Y[r2, 2]) +
t(Vc[t3]) %*% (B[t3, s1] %*% Am[s1, r2] %*% L[r2, r2] %*% Y[r2, 2]) +
t(Vc[t2]) %*% (B[t2, s1] %*% Am[s1, r3] %*% L[r3, r3] %*% Y[r3, 3]) +
t(Vc[t3]) %*% (B[t3, s1] %*% Am[s1, r3] %*% L[r3, r3] %*% Y[r3, 3])
}