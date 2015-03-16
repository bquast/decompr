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
             method = "leontief_output")

# define context
context("output format")

test_that("output size matches", {
  expect_equal( length(lo), 5 )
  expect_equal( dim(lo)[1], 81 )
})

test_that("output format matches", {
  expect_match(typeof( lo[,5]), "double" )
})