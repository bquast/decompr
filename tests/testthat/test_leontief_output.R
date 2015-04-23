# load the package
library(decompr)

# load test data
data(leather)

# leontief decomposition
lo <- decomp(inter,
             final,
             countries,
             industries,
             out,
             method = "leontief",
             post = "output")

# define context (i.e. structure not numbers)
context("output format")

test_that("output size matches", {
  expect_equal( length(lo), 5 )
  expect_equal( dim(lo)[1], 81 )
})

test_that("output format matches", {
  expect_match(typeof( lo[,5]), "double" )
})


# define context
context("output content")

# test output content (i.e. numbers)
test_that("output matches", {
  expect_equal( lo[1, 5],  66.75361799, tolerance = .002 )
  expect_equal( lo[81, 5], 96.78316785, tolerance = .002 )
})
