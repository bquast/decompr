# load the package
library(decompr)

# load test data
data(leather)

# leontief decomposition
# n.b. using default method (Leontief)
# with default post-multiplication (exports)
l <- decomp(inter,
            final,
            countries,
            industries,
            out)

# define context
context("output format")

# test output format (i.e. structure not numbers)
test_that("output size matches", {
  expect_equal( length(l), 5 )
  expect_equal( dim(l)[1], 81 )
})

test_that("output format matches", {
  expect_match( typeof(l[,5]), "double" )
})

# define context
context("output content")

# test output content (i.e. numbers)
test_that("output matches", {
  expect_equal( l[1, 5],  28.52278, tolerance = .002 )
  expect_equal( l[81, 5], 34.74381, tolerance = .002 )
})


