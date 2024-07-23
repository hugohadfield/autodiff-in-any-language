public class Functions
{
    public static Complex[] F(Complex[] x)
    {
        return new Complex[]
        {
            x[0] * x[0],
            x[1] * x[1] * x[1]
        };
    }

    public static Complex[] G(Complex[] x)
    {
        return new Complex[]
        {
            Complex.Cos(x[1]) * Complex.Sin(x[0]),
            Complex.Sin(x[0])
        };
    }
}
