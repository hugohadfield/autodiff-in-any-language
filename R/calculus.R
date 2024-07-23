# Function to calculate the Jacobian using complex step differentiation
get_jacobian <- function(func, state, output_dim) {
  input_dim <- length(state)
  jacobian <- matrix(0, nrow = output_dim, ncol = input_dim)
  h <- 1e-6

  for (i in 1:input_dim) {
    state_perturbed <- as.complex(state)
    state_perturbed[i] <- state_perturbed[i] + complex(real = 0, imaginary = h)
    f_perturbed <- func(state_perturbed)
    for (j in 1:output_dim) {
      jacobian[j, i] <- Im(f_perturbed[j]) / h
    }
  }

  return(jacobian)
}

# Example function f
f <- function(x) {
  return(c(x[1]^2, x[2]^3))
}

# Example function g
g <- function(x) {
  return(c(cos(x[2]) * sin(x[1]), sin(x[1])))
}

# Test cases
test_get_jacobian <- function() {
  # Test case for function f
  x <- c(1.0, 2.0)
  jacobian <- get_jacobian(f, x, 2)
  expected <- matrix(c(2.0, 0.0, 0.0, 12.0), nrow = 2, byrow = TRUE)
  stopifnot(all.equal(jacobian, expected, tolerance = 1e-5))

  # Test case for function g
  two_pi <- 2 * pi
  theta_a_seq <- seq(0, two_pi, length.out = 100)
  theta_b_seq <- seq(0, two_pi, length.out = 100)
  
  for (theta_a in theta_a_seq) {
    for (theta_b in theta_b_seq) {
      x <- c(theta_a, theta_b)
      jacobian <- get_jacobian(g, x, 2)
      expected <- matrix(c(
        cos(x[2]) * cos(x[1]), -sin(x[2]) * sin(x[1]),
        cos(x[1]), 0.0
      ), nrow = 2, byrow = TRUE)
      stopifnot(all.equal(jacobian, expected, tolerance = 1e-5))
    }
  }
  print("All tests passed!")
}

# Run tests
test_get_jacobian()
