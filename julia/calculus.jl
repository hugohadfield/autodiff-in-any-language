
using Test

function get_jacobian(func, state, output_dim)
    input_dim = length(state)
    jacobian = zeros(Complex{Float64}, output_dim, input_dim)
    h = 1e-6

    for i in 1:input_dim
        state_perturbed = Complex{Float64}.(state)
        state_perturbed[i] += im * h
        f_perturbed = func(state_perturbed)
        for j in 1:output_dim
            jacobian[j, i] = imag(f_perturbed[j]) / h
        end
    end

    return jacobian
end


function f(x)
    return [x[1]^2; x[2]^3]
end

function g(x)
    return [cos(x[2]) * sin(x[1]); sin(x[1])]
end


function test_get_jacobian()
    # Test case for function f
    x = [1.0, 2.0]
    jacobian = get_jacobian(f, x, 2)
    expected = [2.0 0.0; 0.0 12.0]
    @test isapprox(jacobian, expected, atol=1e-5)

    # Test case for function g
    two_pi = 2 * π
    for theta_a in 0:π/50:two_pi
        for theta_b in 0:π/50:two_pi
            x = [theta_a, theta_b]
            jacobian = get_jacobian(g, x, 2)
            expected = [cos(x[2]) * cos(x[1]) -sin(x[2]) * sin(x[1]);
                        cos(x[1]) 0.0]
            @test isapprox(jacobian, expected, atol=1e-5)
        end
    end
    println("All tests passed!")
end
