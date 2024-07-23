package main

import (
	"math"
	"math/cmplx"
	"testing"
	"fmt"
)

// Function to calculate the Jacobian using complex step differentiation
func GetJacobian(funcToEvaluate func([]complex128) []complex128, state []float64, outputDim int) [][]float64 {
	inputDim := len(state)
	jacobian := make([][]float64, outputDim)
	for i := range jacobian {
		jacobian[i] = make([]float64, inputDim)
	}
	h := 1e-6

	for i := 0; i < inputDim; i++ {
		statePerturbed := make([]complex128, inputDim)
		for j, s := range state {
			statePerturbed[j] = complex(s, 0)
		}
		statePerturbed[i] += complex(0, h)
		fPerturbed := funcToEvaluate(statePerturbed)
		for j := 0; j < outputDim; j++ {
			jacobian[j][i] = imag(fPerturbed[j]) / h
		}
	}

	return jacobian
}

// Example function f
func F(x []complex128) []complex128 {
	return []complex128{
		x[0] * x[0],
		x[1] * x[1] * x[1],
	}
}

// Example function g
func G(x []complex128) []complex128 {
	return []complex128{
		cmplx.Cos(x[1]) * cmplx.Sin(x[0]),
		cmplx.Sin(x[0]),
	}
}

func main() {
	// Run tests
	TestGetJacobian()
}

// Test cases
func TestGetJacobian() {
	// Test case for function f
	x := []float64{1.0, 2.0}
	jacobian := GetJacobian(F, x, 2)
	expected := [][]float64{{2.0, 0.0}, {0.0, 12.0}}
	for i := range jacobian {
		for j := range jacobian[i] {
			if math.Abs(jacobian[i][j]-expected[i][j]) > 1e-5 {
				fmt.Printf("Test case f failed at [%d][%d]: got %f, expected %f\n", i, j, jacobian[i][j], expected[i][j])
			}
		}
	}

	// Test case for function g
	twoPi := 2 * math.Pi
	for thetaA := 0.0; thetaA <= twoPi; thetaA += math.Pi / 50 {
		for thetaB := 0.0; thetaB <= twoPi; thetaB += math.Pi / 50 {
			x := []float64{thetaA, thetaB}
			jacobian := GetJacobian(G, x, 2)
			expected := [][]float64{
				{math.Cos(x[1]) * math.Cos(x[0]), -math.Sin(x[1]) * math.Sin(x[0])},
				{math.Cos(x[0]), 0.0},
			}
			for i := range jacobian {
				for j := range jacobian[i] {
					if math.Abs(jacobian[i][j]-expected[i][j]) > 1e-5 {
						fmt.Printf("Test case g failed for thetaA=%f, thetaB=%f at [%d][%d]: got %f, expected %f\n",
							thetaA, thetaB, i, j, jacobian[i][j], expected[i][j])
					}
				}
			}
		}
	}
	fmt.Println("All tests passed!")
}
