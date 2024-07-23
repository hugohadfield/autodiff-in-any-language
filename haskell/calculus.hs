import Data.Complex
import Numeric.LinearAlgebra (Matrix, fromLists, toLists, (><))
import Numeric.LinearAlgebra.Data (matrix)
import Test.HUnit
import Control.Monad (forM_)

-- Function to calculate the Jacobian using complex step differentiation
getJacobian :: ([Complex Double] -> [Complex Double]) -> [Double] -> Int -> [[Double]]
getJacobian func state outputDim = toLists $ matrix outputDim $ concat jacobianElements
  where
    inputDim = length state
    h = 1e-6
    jacobianElements = [ [ (imagPart (fPerturbed !! j)) / h | j <- [0..outputDim-1] ]
                       | i <- [0..inputDim-1],
                         let statePerturbed = [ if k == i then x + (0 :+ h) else x | (x, k) <- zip (map (:+ 0) state) [0..] ],
                         let fPerturbed = func statePerturbed ]

-- Example function f
f :: [Complex Double] -> [Complex Double]
f [x1, x2] = [x1 * x1, x2 * x2 * x2]

-- Example function g
g :: [Complex Double] -> [Complex Double]
g [x1, x2] = [cos x2 * sin x1, sin x1]

-- Test case for function f
testGetJacobianF = TestCase $ do
    let x = [1.0, 2.0]
    let jacobian = getJacobian f x 2
    let expected = [[2.0, 0.0], [0.0, 12.0]]
    assertEqual "Test case f failed" expected jacobian

-- Test case for function g
testGetJacobianG = TestCase $ do
    let twoPi = 2 * pi
    forM_ [0, pi/50 .. twoPi] $ \thetaA ->
      forM_ [0, pi/50 .. twoPi] $ \thetaB -> do
        let x = [thetaA, thetaB]
        let jacobian = getJacobian g x 2
        let expected = [[cos thetaB * cos thetaA, -sin thetaB * sin thetaA],
                        [cos thetaA, 0.0]]
        assertBool ("Test case g failed for thetaA=" ++ show thetaA ++ ", thetaB=" ++ show thetaB)
                   (and $ zipWith (all . absDiff (1e-5)) jacobian expected)
  where
    absDiff tol a b = abs (a - b) < tol

main :: IO ()
main = do
  _ <- runTestTT (TestList [testGetJacobianF, testGetJacobianG])
  return ()
