# load the package
library(decompr)

# load test data
data(leather)

# WWZ decomposition
w <- decomp(inter,
            final,
            countries,
            industries,
            out,
            method = "wwz")

# define context
context("output format")

test_that("output size matches", {
  expect_equal(length(w), 29 )
  expect_equal(dim(w)[1], 27 )
})

test_that("output format matches", {
  expect_match(typeof(w[,5]), "double")
})


# test that verbose turns some messages on
test_that("verbose computation 1/2",
          expect_message(decomp(inter, final, countries, industries,
                                out, method = "wwz", verbose = TRUE),
                         "Starting decomposing the trade flow"))

test_that("verbose computation 2/2",
          expect_message(decomp(inter, final, countries, industries,
                                out, method = "wwz", verbose = TRUE),
                         "16/16, elapsed time:"))

##
## Custom v
## 
context("custom v")

va <- out - colSums(inter)

## WWZ decomposition: specify v
w.2 <- decomp(inter,
              final,
              countries,
              industries,
              out,
              v = va,
              method = "wwz")

test_that("specifying v leaves output unchanged",
          expect_identical(w.2, w))


## WWZ decomposition: only argentina
va[4:9] <- 0
w.arg <- decomp(inter,
                final,
                countries,
                industries,
                out,
                v = va,
                method = "wwz")

test_that("only argentina has positive numbers",
          expect_true(any(w.arg$DVA_FIN[1:9] > 0)))

test_that("turkey and germany are 0",
          expect_true(all(w.arg$DVA_FIN[10:27] == 0)))


## now we only care about the transport_equipment industry
va <- out - colSums(inter)
va[1:9 %% 3 != 0] <- 0
w.transport <- decomp(inter,
                final,
                countries,
                industries,
                out,
                v = va,
                method = "wwz")

within.country <- w.transport[w.transport$Exporting_Country == w.transport$Importing_Country, "DVA_FIN"]
test_that("only within-country flows are 0",
          expect_true(all(within.country == 0)))

non_within.country <- w.transport[w.transport$Exporting_Country != w.transport$Importing_Country, "DVA_FIN"]
test_that("all others should be greater than 0",
          expect_true(all(non_within.country > 0)))
