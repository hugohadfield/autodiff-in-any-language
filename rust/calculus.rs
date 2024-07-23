use nalgebra::{DMatrix, DVector};
use num_complex::Complex;
use proptest::prelude::*;
use std::f64::consts::PI;

// Define the Jacobian calculation function
fn get_jacobian<F>(
    function: F,
    state: &DVector<f64>,
    output_dim: usize,
) -> DMatrix<f64>
where
    F: Fn(&DVector<Complex<f64>>) -> DVector<Complex<f64>>,
{
    let input_dim = state.len();
    let mut jacobian = DMatrix::<f64>::zeros(output_dim, input_dim);
    let h = 1e-6;

    for i in 0..input_dim {
        let mut state_perturbed = DVector::<Complex<f64>>::from_vec(
            state.iter().map(|&x| Complex::new(x, 0.0)).collect(),
        );
        state_perturbed[i] += Complex::new(0.0, h);
        let f_perturbed = function(&state_perturbed);
        for j in 0..output_dim {
            jacobian[(j, i)] = f_perturbed[j].im / h;
        }
    }

    jacobian
}

// Define example functions for testing
fn f(x: &DVector<Complex<f64>>) -> DVector<Complex<f64>> {
    let mut result = DVector::<Complex<f64>>::zeros(2);
    result[0] = x[0] * x[0];
    result[1] = x[1] * x[1] * x[1];
    result
}

fn g(x: &DVector<Complex<f64>>) -> DVector<Complex<f64>> {
    let mut result = DVector::<Complex<f64>>::zeros(2);
    result[0] = x[1].cos() * x[0].sin();
    result[1] = x[0].sin();
    result
}

// Test cases using proptest
proptest! {
    #[test]
    fn test_get_jacobian_f() {
        let x = DVector::<f64>::from_vec(vec![1.0, 2.0]);
        let jacobian = get_jacobian(f, &x, 2);
        let expected = DMatrix::from_vec(2, 2, vec![2.0, 0.0, 0.0, 12.0]);
        prop_assert!(jacobian.abs_diff_eq(&expected, 1e-5));
    }

    #[test]
    fn test_get_jacobian_g(theta_a in 0.0..=2.0 * PI, theta_b in 0.0..=2.0 * PI) {
        let x = DVector::<f64>::from_vec(vec![theta_a, theta_b]);
        let jacobian = get_jacobian(g, &x, 2);
        let expected = DMatrix::from_vec(2, 2, vec![
            theta_b.cos() * theta_a.cos(), -theta_b.sin() * theta_a.sin(),
            theta_a.cos(), 0.0
        ]);
        prop_assert!(jacobian.abs_diff_eq(&expected, 1e-5));
    }
}

fn main() {
    // Optionally, you can run additional standalone tests here
    let x = DVector::<f64>::from_vec(vec![1.0, 2.0]);
    let jacobian = get_jacobian(f, &x, 2);
    println!("Jacobian for f at [1.0, 2.0]:\n{}", jacobian);

    let x = DVector::<f64>::from_vec(vec![PI / 4.0, PI / 4.0]);
    let jacobian = get_jacobian(g, &x, 2);
    println!("Jacobian for g at [PI/4, PI/4]:\n{}", jacobian);
}
