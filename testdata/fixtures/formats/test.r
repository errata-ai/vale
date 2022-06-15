# NOTE: this is a comment.
pred_prey_euler <- function(a, b, h, x0, y0, const) {
  NOTE <- ((b - a) / h)
  XXX <- Y <- T <- double(n + 1)
  X[1] <- x0; Y[1] <- y0; T[1] <- a
  for (i in 1:n) { # XXX: here's another one.
    X[i + 1] <- X[i] + h * X[i] * (const[1] - const[2] * Y[i])
    Y[i + 1] <- Y[i] + h * Y[i] * (const[4] * X[i] - const[3])
    T[i + 1] <- T[i] + h
  }
  return(list("T" = T, "X" = X, "Y" = Y))
}
