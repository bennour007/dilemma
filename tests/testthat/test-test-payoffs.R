test_that("defecting pays more whatever the peer does", {
  p <- set_payoffs()
  expect_gt(p[["temptation"]], p[["reward"]])
  expect_gt(p[["punishment"]], p[["sucker"]])
})

test_that("payoffs that are not a dilemma warn", {
  expect_warning(set_payoffs(temptation = 0.5))
})

test_that("each game pays the right payoff", {
  expect_equal(
    payoff_rule(c("cooperate", "cooperate", "defect", "defect"),
                c("cooperate", "defect", "cooperate", "defect")),
    c(1, -1, 1.2, 0)
  )
})
