function testGetJacobian()
    % Test case for function f
    x = [1.0; 2.0];
    jacobian = getJacobian(@f, x, 2);
    expected = [2.0, 0.0; 0.0, 12.0];
    assert(isequal(round(jacobian, 10), round(expected, 10)), 'Test case f failed');

    % Test case for function g
    twoPi = 2 * pi;
    for theta_a = linspace(0, twoPi, 100)
        for theta_b = linspace(0, twoPi, 100)
            x = [theta_a; theta_b];
            jacobian = getJacobian(@g, x, 2);
            expected = [cos(x(2)) * cos(x(1)), -sin(x(2)) * sin(x(1));
                        cos(x(1)), 0.0];
            assert(isequal(round(jacobian, 10), round(expected, 10)), ...
                   'Test case g failed for theta_a=%.2f, theta_b=%.2f', theta_a, theta_b);
        end
    end
    disp('All tests passed!');
end
