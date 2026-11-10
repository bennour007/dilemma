test_that("the number of defectors is exact", {
  d <- assign_decisions(200, 0.25)
  expect_length(d, 200)
  expect_equal(sum(d == "defect"), 50)
})

test_that("the share must be between 0 and 1", {
  expect_error(assign_decisions(10, 1.5))
})
