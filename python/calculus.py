
from typing import Callable

import numpy as np


def get_jacobian(function: Callable, state: np.ndarray, dimension: int):
    """
    Complex step autodiff
    """
    # Get dimensionality of input
    input_dims = len(state)

    # Create an output in the correct shape and of same type as input
    jacobian = np.zeros((dimension, input_dims), dtype=state.dtype)

    # Perturbation size
    h = 1e-6

    # Iterate over each dimension of the input
    for i in range(input_dims):
        # Perturb the input
        state_perturbed = np.zeros_like(state, dtype=np.complex128) + state
        state_perturbed[i] += 1j*h

        # Evaluate the function at the perturbed input
        f_perturbed = function(state_perturbed)

        # Compute the derivative
        jacobian[:, i] = np.imag(f_perturbed) / h
    
    return jacobian


def test_get_jacobian():
    def f(x):
        return np.array([x[0]**2, x[1]**3])

    x = np.array([1.0, 2.0])
    jacobian = get_jacobian(f, x, 2)
    np.testing.assert_allclose(jacobian, np.array([[2.0, 0.0], [0.0, 12.0]]))

    def g(x):
        return np.array([np.cos(x[1])*np.sin(x[0]), np.sin(x[0])])

    for theta_a in np.linspace(0, 2*np.pi, 100):
        for theta_b in np.linspace(0, 2*np.pi, 100):
            x = np.array([theta_a, theta_b])
            jacobian = get_jacobian(g, x, 2)
            np.testing.assert_allclose(
                jacobian, 
                np.array(
                    [
                        [np.cos(x[1])*np.cos(x[0]), np.cos(x[0])], 
                        [-np.sin(x[1])*np.sin(x[0]), 0.0]
                    ]
                )
            )

if __name__ == "__main__":
    test_get_jacobian()
    print("All tests passed")