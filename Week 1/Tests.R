a <- 'numeric'
b <- c(14, 29, 42, 890)
a == class(b) | b[1] > b[2]

mat_data <- c('mouse', 'cat', 'dog', 'hamster', 'snake', 'bird')
animals_mat <- matrix(mat_data,
                      nrow = 2,
                      byrow = FALSE)
animals_mat[2,1]