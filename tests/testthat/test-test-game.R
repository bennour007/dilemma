test_that("one defector takes over a one-peer ring", {
  set.seed(1)
  res <- simulate_game(one_peer(10), prop_defect = 0.1, n_rounds = 20)
  expect_equal(nrow(res), 21)
  expect_equal(res$defectors[res$round == 20], 1)
})

test_that("without defectors, everyone keeps cooperating", {
  for (rule in c("mean", "median", "sum", "random")) {
    res <- simulate_game(tidygraph::create_complete(10), prop_defect = 0,
                         rule = rule, n_rounds = 5)
    expect_true(all(res$defectors == 0))
  }
})

test_that("with one peer, all rules give the same game", {
  runs <- lapply(c("mean", "median", "sum", "random"), \(rule) {
    set.seed(3)
    simulate_game(one_peer(30), prop_defect = 0.2, rule = rule, n_rounds = 30)
  })
  for (run in runs[-1]) expect_equal(run, runs[[1]])
})

test_that("detail gives one row per player per round", {
  res <- simulate_game(one_peer(6), prop_defect = 0.5, n_rounds = 3, detail = TRUE)
  expect_equal(nrow(res), 6 * 4)
})

test_that("a typo in the rule is an error", {
  expect_error(simulate_game(one_peer(6), rule = "meen"))
})
