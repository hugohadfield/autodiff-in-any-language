using System;
using NUnit.Framework;

[TestFixture]
public class JacobianTests
{
    [Test]
    public void TestGetJacobianF()
    {
        double[] x = { 1.0, 2.0 };
        double[,] jacobian = JacobianCalculator.GetJacobian(Functions.F, x, 2);
        double[,] expected = { { 2.0, 0.0 }, { 0.0, 12.0 } };

        Assert.IsTrue(IsApproximatelyEqual(jacobian, expected, 1e-5));
    }

    [Test]
    public void TestGetJacobianG()
    {
        double twoPi = 2 * Math.PI;
        for (double theta_a = 0; theta_a <= twoPi; theta_a += Math.PI / 50)
        {
            for (double theta_b = 0; theta_b <= twoPi; theta_b += Math.PI / 50)
            {
                double[] x = { theta_a, theta_b };
                double[,] jacobian = JacobianCalculator.GetJacobian(Functions.G, x, 2);
                double[,] expected = {
                    { Math.Cos(x[1]) * Math.Cos(x[0]), -Math.Sin(x[1]) * Math.Sin(x[0]) },
                    { Math.Cos(x[0]), 0.0 }
                };

                Assert.IsTrue(IsApproximatelyEqual(jacobian, expected, 1e-5), 
                    $"Test case G failed for theta_a={theta_a}, theta_b={theta_b}");
            }
        }
    }

    private bool IsApproximatelyEqual(double[,] a, double[,] b, double tolerance)
    {
        int rows = a.GetLength(0);
        int cols = a.GetLength(1);

        for (int i = 0; i < rows; i++)
        {
            for (int j = 0; j < cols; j++)
            {
                if (Math.Abs(a[i, j] - b[i, j]) > tolerance)
                {
                    return false;
                }
            }
        }

        return true;
    }
}
