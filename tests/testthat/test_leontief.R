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

test_that("Output format matches", {
  expect_equal(length(l), 5 )
})