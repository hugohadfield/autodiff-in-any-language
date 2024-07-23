import static org.junit.jupiter.api.Assertions.assertArrayEquals;

import org.junit.jupiter.api.Test;

public class JacobianTests {

    @Test
    public void testGetJacobianF() {
        double[] x = {1.0, 2.0};
        double[][] jacobian = JacobianCalculator.getJacobian(Functions::f, x, 2);
        double[][] expected = {
            {2.0, 0.0},
            {0.0, 12.0}
        };

        assertArrayEquals(expected, jacobian);
    }

    @Test
    public void testGetJacobianG() {
        double twoPi = 2 * Math.PI;
        for (double theta_a = 0; theta_a <= twoPi; theta_a += Math.PI / 50) {
            for (double theta_b = 0; theta_b <= twoPi; theta_b += Math.PI / 50) {
                double[] x = {theta_a, theta_b};
                double[][] jacobian = JacobianCalculator.getJacobian(Functions::g, x, 2);
                double[][] expected = {
                    {Math.cos(x[1]) * Math.cos(x[0]), -Math.sin(x[1]) * Math.sin(x[0])},
                    {Math.cos(x[0]), 0.0}
                };

                assertArrayEquals(expected, jacobian, 1e-5);
            }
        }
    }
}
