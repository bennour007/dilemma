#' A network where every player has one peer
#'
#' Players sit on a single directed loop: each one plays and compares with the
#' next. Every player can be reached from every other, so nobody is cut off.
#'
#' @param n_players Number of players.
#'
#' @return A `tbl_graph`.
#' @export
#'
#' @examples
#' one_peer(6)
one_peer <- function(n_players) {
  tidygraph::create_ring(n_players, directed = TRUE)
}

#' The games a network implies
#'
#' One row per game: the player and the peer they play with. In an undirected
#' network every friendship is played both ways; in a directed one, only in
#' the direction of the tie.
#'
#' @param network An `igraph` or `tbl_graph` network.
#'
#' @return A tibble with columns `player` and `peer`.
#' @export
#'
#' @examples
#' peers_from_graph(tidygraph::create_path(3))
peers_from_graph <- function(network) {
  edgelist <- igraph::as_edgelist(network, names = FALSE)

  edges <- tibble(player = edgelist[, 1], peer = edgelist[, 2]) |>
    filter(player != peer)

  if (igraph::is_directed(network)) return(edges)

  bind_rows(edges, select(edges, player = peer, peer = player)) |>
    distinct()
}
