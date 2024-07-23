# Automatic Differentiation in any Programming Language
This repository demonstrates Automatic differentiation in a range of programming languages using forward mode complex-step automatic differentiation.

Blog post soon to be published on [my website](https://hh409.user.srcf.net/).

## Introduction
Automatic differentiation (AD) is a set of techniques to numerically evaluate the derivative of a function specified by a computer program. AD exploits the fact that every computer program, no matter how complicated, executes a sequence of elementary arithmetic operations (addition, subtraction, multiplication, division, etc.) and elementary functions (exp, log, sin, cos, etc.). By applying the chain rule repeatedly to these operations, derivatives of arbitrary order can be computed automatically, accurately to working precision, and using at most a small constant factor more arithmetic operations than the original program.

Here we are looking specifically at **forward mode automatic differentiation**. Forward mode AD is one of the two types of automatic differentiation in common usage and is much simpler to implement than reverse mode autodiff.

In this repository, we provide a simple implementation of forward mode automatic differentiation using the complex-step method. The complex-step method is a way to compute the derivative of a real-valued function using complex arithmetic. The method is very accurate and efficient and most importantly, it is very easy to implement in almost any programming language as almost all modern math libraries support complex arithmetic.

## Repository Structure
The repository is structured with one folder for each programming language. Each folder contains a simple implementation of forward mode automatic differentiation using the complex-step method. The implementations are kept as simple as possible to make it easy to understand and there is some simple test code to demonstrate how to use the implementations. The following languages are currently supported:
- Python
- Julia
- C++
- C#
- JavaScript
- MATLAB
- Rust
- Java
- R
- Go

I've started off the implementations by writing the Python one and the rest are based on that, with a little bit of help from our good old friend `ChatGPT`. If anyone fancies adding a new language or improving one of the existing implementations, that would be very welcome!

## The math behind the complex-step method
For a real-valued function $f(x)$, the derivative can be computed using the complex-step method as follows:
1. Replace the real variable $x$ with a complex variable $z = x + ih$ where $i$ is the imaginary unit and $h$ is a small step size.
2. Compute the function value $f(z)$ using complex arithmetic.
3. The derivative of $f(x)$ is then given by the imaginary part of $f(z)$ divided by $h$.

