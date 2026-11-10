# How a player scores their own games, and how they summarise their peers' scores.
# With "sum", a player's total is compared with the average peer's total.
score_fns     <- list(sum = sum,  mean = mean, median = median, random = mean)
benchmark_fns <- list(sum = mean, mean = mean, median = median, random = mean)

check_rule <- function(rule) {
  match.arg(rule, c("mean", "median", "sum", "random"))
}

# the decision of the best-scoring peer
best_decision <- function(decisions, scores) {
  if (all(is.na(scores))) return(NA_character_)
  decisions[which.max(scores)]
}

# nothing can change any more: everyone agrees, or a fixed rule made no switch
is_settled <- function(new, old, rule) {
  n_distinct(new) == 1 || (rule != "random" && identical(new, old))
}

# runs that stopped early keep their last state until the final round
pad_history <- function(history, n_rounds) {
  missing <- n_rounds + 1 - length(history)
  c(history, rep(list(history[[length(history)]]), missing))
}
