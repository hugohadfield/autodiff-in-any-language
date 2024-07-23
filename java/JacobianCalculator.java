import org.apache.commons.math3.complex.Complex;

public class JacobianCalculator {

    public static double[][] getJacobian(Function<Complex[], Complex[]> func, double[] state, int outputDim) {
        int inputDim = state.length;
        double[][] jacobian = new double[outputDim][inputDim];
        double h = 1e-6;

        for (int i = 0; i < inputDim; i++) {
            Complex[] statePerturbed = new Complex[state.length];
            for (int j = 0; j < state.length; j++) {
                statePerturbed[j] = new Complex(state[j], 0);
            }
            statePerturbed[i] = statePerturbed[i].add(new Complex(0, h));
            Complex[] fPerturbed = func.apply(statePerturbed);

            for (int j = 0; j < outputDim; j++) {
                jacobian[j][i] = fPerturbed[j].getImaginary() / h;
            }
        }

        return jacobian;
    }

    @FunctionalInterface
    public interface Function<T, R> {
        R apply(T t);
    }
}
