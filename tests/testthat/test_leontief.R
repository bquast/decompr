# load the package
library(decompr)

# load test data
data(leather)

# leontief decomposition
l <- decomp(inter,
            final,
            countries,
            industries,
            out,
            method = "leontief")

# define context
context("output format")

test_that("output size matches", {
  expect_equal(length(l), 5 )
  expect_equal(dim(l)[1], 81 )
})

test_that("output format matches", {
  expect_match(typeof(l[,5]), "double")
})