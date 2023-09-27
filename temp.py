import numpy as np
from numpy.linalg import norm

# Define the function
def solve_jacobi(A, b, tol=1e-2):
    
    # Set initial guess
    x = b + 1e-16
        
    # Initialize variables
    x_diff = 1
    N = len(A)
    it_jac = 1
    
    while ( x_diff > tol and it_jac < 1000 ):
        x_old = np.copy(x)
        for i in range(N):
            # Sum off-diagonal*x_old
            offDiagonalIndex = np.concatenate((np.arange(0, i), np.arange(i+1, N)))
            Aij_Xj = np.dot(A[i, offDiagonalIndex], x_old[offDiagonalIndex])

            # Compute new x value
            x[i] = (b[i] - Aij_Xj) / A[i, i]
        it_jac += 1
        x_diff = np.linalg.norm((x - x_old), ord=2)
        
    # Print number of iterations
    print(it_jac)
    
    return x, it_jac


A = np.array([[4, -1, 0, 0], [-1, 4, -1, 0], [0, -1, 4, -1], [0, 0, -1, 3]])
b = np.array([15, 10, 10, 10])
x = np.linalg.solve(A,b)
x_ = solve_jacobi(A,b, 1e-6)[0]
print(x, x_)