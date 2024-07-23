function jacobian = getJacobian(func, state, outputDim)
    % Get dimensionality of input
    inputDim = length(state);
    % Create an output in the correct shape and of same type as input
    jacobian = zeros(outputDim, inputDim);
    % Perturbation size
    h = 1e-6;

    % Iterate over each dimension of the input
    for i = 1:inputDim
        % Perturb the input
        statePerturbed = complex(state);
        statePerturbed(i) = statePerturbed(i) + 1i * h;
        % Evaluate the function at the perturbed input
        fPerturbed = func(statePerturbed);
        % Compute the derivative
        jacobian(:, i) = imag(fPerturbed) / h;
    end
end
