const math = require('mathjs');

// Define the Jacobian calculation function
function getJacobian(func, state, outputDim) {
    const inputDim = state.size()[0];
    const jacobian = math.zeros(outputDim, inputDim);
    const h = 1e-6;

    for (let i = 0; i < inputDim; i++) {
        const statePerturbed = math.complex(state);
        statePerturbed.set([i], math.add(statePerturbed.get([i]), math.complex(0, h)));
        const fPerturbed = func(statePerturbed);
        for (let j = 0; j < outputDim; j++) {
            jacobian.set([j, i], math.divide(math.im(fPerturbed.get([j])), h));
        }
    }

    return jacobian;
}

// Define example functions for testing
function f(x) {
    const result = math.zeros(2);
    result.set([0], math.square(x.get([0])));
    result.set([1], math.pow(x.get([1]), 3));
    return result;
}

function g(x) {
    const result = math.zeros(2);
    result.set([0], math.multiply(math.cos(x.get([1])), math.sin(x.get([0]))));
    result.set([1], math.sin(x.get([0])));
    return result;
}

// Test cases
function testGetJacobian() {
    let x = math.matrix([1.0, 2.0]);
    let jacobian = getJacobian(f, x, 2);
    let expected = math.matrix([[2.0, 0.0], [0.0, 12.0]]);
    console.assert(math.deepEqual(jacobian, expected), 'Test case f failed');

    const twoPi = 2 * Math.PI;
    for (let theta_a = 0; theta_a <= twoPi; theta_a += Math.PI / 50) {
        for (let theta_b = 0; theta_b <= twoPi; theta_b += Math.PI / 50) {
            x = math.matrix([theta_a, theta_b]);
            jacobian = getJacobian(g, x, 2);
            expected = math.matrix([
                [math.cos(x.get([1])) * math.cos(x.get([0])), -math.sin(x.get([1])) * math.sin(x.get([0]))],
                [math.cos(x.get([0])), 0.0]
            ]);
            console.assert(math.deepEqual(jacobian, expected), `Test case g failed for theta_a=${theta_a}, theta_b=${theta_b}`);
        }
    }
    console.log('All tests passed!');
}

// Run tests
testGetJacobian();
