import org.apache.commons.math3.complex.Complex;

public class Functions {

    public static Complex[] f(Complex[] x) {
        return new Complex[]{
            x[0].multiply(x[0]),
            x[1].multiply(x[1]).multiply(x[1])
        };
    }

    public static Complex[] g(Complex[] x) {
        return new Complex[]{
            x[1].cos().multiply(x[0].sin()),
            x[0].sin()
        };
    }
}
