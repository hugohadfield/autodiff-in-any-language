using System;
using System.Numerics;

public class JacobianCalculator
{
    public static double[,] GetJacobian(Func<Complex[], Complex[]> func, double[] state, int outputDim)
    {
        int inputDim = state.Length;
        double[,] jacobian = new double[outputDim, inputDim];
        double h = 1e-6;

        for (int i = 0; i < inputDim; i++)
        {
            Complex[] statePerturbed = Array.ConvertAll(state, x => new Complex(x, 0));
            statePerturbed[i] += new Complex(0, h);
            Complex[] fPerturbed = func(statePerturbed);

            for (int j = 0; j < outputDim; j++)
            {
                jacobian[j, i] = fPerturbed[j].Imaginary / h;
            }
        }

        return jacobian;
    }
}
