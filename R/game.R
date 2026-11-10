#' Play one round
#'
#' Every player plays all their games, scores them with `rule`, compares the
#' score with their peers', and copies the best peer if the peers did better.
#'
#' @param decisions Character vector of current decisions, one per player.
#' @param peers Table of games from [peers_from_graph()].
#' @param rule How players judge success: `"mean"`, `"median"`, `"sum"`, or
#'   `"random"` (compare with one random peer).
#' @param payoffs Payoffs from [set_payoffs()].
#'
#' @return The decisions for the next round.
#' @export
play_round <- function(decisions, peers, rule = "mean", payoffs = set_payoffs()) {
  rule <- check_rule(rule)

  # every game this round
  games <- peers |>
    mutate(
      decision_player = decisions[player],
      decision_peer   = decisions[peer],
      payoff_player   = payoff_rule(decision_player, decision_peer, payoffs)
    )

  # each player's score, attached to both sides of each game
  scores <- games |>
    summarise(score = score_fns[[rule]](payoff_player), .by = player)

  score <- rep(NA_real_, length(decisions))
  score[scores$player] <- scores$score

  games <- games |>
    mutate(score_player = score[player], score_peer = score[peer])

  # the random rule looks at a single peer
  if (rule == "random") games <- slice_sample(games, n = 1, by = player)

  # copy the best peer if the peers did better
  switches <- games |>
    summarise(
      benchmark     = benchmark_fns[[rule]](score_peer, na.rm = TRUE),
      score_player  = first(score_player),
      decision_best = best_decision(decision_peer, score_peer),
      .by = player
    ) |>
    filter(benchmark > score_player)

  decisions[switches$player] <- switches$decision_best
  decisions
}

#' Play a full game
#'
#' Plays rounds until `n_rounds`, or until nothing can change any more. Runs
#' that stop early are padded with their last state, so every run has
#' `n_rounds + 1` rounds. Call `set.seed()` before drawing a random network to
#' get the same network and start for every rule.
#'
#' @param network An `igraph` or `tbl_graph` network.
#' @param prop_defect Share of players who start by defecting.
#' @param n_rounds Number of rounds after the starting round.
#' @param detail If `FALSE`, the share of defectors per round. If `TRUE`, every
#'   player's decision in every round.
#' @inheritParams play_round
#'
#' @return A tibble.
#' @export
#'
#' @examples
#' simulate_game(one_peer(20), prop_defect = 0.1, n_rounds = 20)
simulate_game <- function(network,
                          prop_defect = 0.25,
                          rule        = "mean",
                          n_rounds    = 100,
                          payoffs     = set_payoffs(),
                          detail      = FALSE) {
  rule      <- check_rule(rule)
  peers     <- peers_from_graph(network)
  n_players <- igraph::vcount(network)
  start     <- assign_decisions(n_players, prop_defect)

  step <- function(decisions, round) {
    new <- play_round(decisions, peers, rule, payoffs)
    if (is_settled(new, decisions, rule)) done(new) else new
  }

  history <- accumulate(seq_len(n_rounds), step, .init = start) |>
    pad_history(n_rounds)

  if (detail) {
    return(tibble(
      round    = rep(0:n_rounds, each = n_players),
      player   = rep(seq_len(n_players), times = n_rounds + 1),
      decision = unlist(history)
    ))
  }

  tibble(
    round     = 0:n_rounds,
    defectors = map_dbl(history, \(d) mean(d == "defect"))
  )
}
