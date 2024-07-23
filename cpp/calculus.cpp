#include <iostream>
#include <Eigen/Dense>
#include <complex>
#include <functional>
#include <cmath>
#include <gtest/gtest.h>

// Define a template function to get the Jacobian matrix
template<typename Func, typename Scalar, int InputDim, int OutputDim>
Eigen::Matrix<Scalar, OutputDim, InputDim> getJacobian(const Func& function, const Eigen::Matrix<Scalar, InputDim, 1>& state) {
    // Define types for convenience
    using VectorType = Eigen::Matrix<Scalar, InputDim, 1>;
    using ComplexVectorType = Eigen::Matrix<std::complex<Scalar>, InputDim, 1>;
    using JacobianType = Eigen::Matrix<Scalar, OutputDim, InputDim>;

    // Create an output in the correct shape and of same type as input
    JacobianType jacobian = JacobianType::Zero();
    // Perturbation size
    Scalar h = 1e-6;

    // Iterate over each dimension of the input
    for (int i = 0; i < InputDim; ++i) {
        // Perturb the input
        ComplexVectorType statePerturbed = state.template cast<std::complex<Scalar>>();
        statePerturbed[i] += std::complex<Scalar>(0, h);
        // Evaluate the function at the perturbed input
        auto fPerturbed = function(statePerturbed);
        // Compute the derivative
        jacobian.col(i) = fPerturbed.imag() / h;
    }

    return jacobian;
}

// Example functions to test getJacobian
template<typename T>
Eigen::Matrix<T, 2, 1> f(const Eigen::Matrix<T, 2, 1>& x) {
    Eigen::Matrix<T, 2, 1> result;
    result[0] = x[0] * x[0];
    result[1] = x[1] * x[1] * x[1];
    return result;
}

template<typename T>
Eigen::Matrix<T, 2, 1> g(const Eigen::Matrix<T, 2, 1>& x) {
    Eigen::Matrix<T, 2, 1> result;
    result[0] = std::cos(x[1]) * std::sin(x[0]);
    result[1] = std::sin(x[0]);
    return result;
}

// Test cases using Google Test
TEST(GetJacobianTest, TestF) {
    Eigen::Vector2d x;
    x << 1.0, 2.0;
    auto jacobian = getJacobian(f<std::complex<double>>, x);
    Eigen::Matrix2d expected;
    expected << 2.0, 0.0, 0.0, 12.0;
    ASSERT_TRUE(jacobian.isApprox(expected, 1e-5));
}

TEST(GetJacobianTest, TestG) {
    for (double theta_a = 0; theta_a <= 2 * M_PI; theta_a += M_PI / 50) {
        for (double theta_b = 0; theta_b <= 2 * M_PI; theta_b += M_PI / 50) {
            Eigen::Vector2d x;
            x << theta_a, theta_b;
            auto jacobian = getJacobian(g<std::complex<double>>, x);
            Eigen::Matrix2d expected;
            expected << std::cos(x[1]) * std::cos(x[0]), -std::sin(x[1]) * std::sin(x[0]),
                        std::cos(x[0]), 0.0;
            ASSERT_TRUE(jacobian.isApprox(expected, 1e-5));
        }
    }
}

int main(int argc, char **argv) {
    ::testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
