test_that("undirected ties are played both ways", {
  peers <- peers_from_graph(tidygraph::create_path(3))   # 1-2, 2-3
  expect_equal(nrow(peers), 4)
  expect_setequal(peers$peer[peers$player == 2], c(1, 3))
})

test_that("with one peer, every player has exactly one game", {
  peers <- peers_from_graph(one_peer(5))
  expect_equal(sort(peers$player), 1:5)
})
