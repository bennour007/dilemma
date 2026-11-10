#' Payoffs of the prisoner's dilemma
#'
#' @param reward Both cooperate.
#' @param sucker You cooperate, the other defects.
#' @param temptation You defect, the other cooperates.
#' @param punishment Both defect.
#' @return A named numeric vector.
#' @export
set_payoffs <- function(reward = 1, sucker = -1, temptation = 1.2, punishment = 0) {
  if (!(temptation > reward && reward > punishment && punishment >= sucker)) {
    warning("These payoffs are not a prisoner's dilemma (T > R > P >= S).")
  }
  c(reward = reward, sucker = sucker, temptation = temptation, punishment = punishment)
}



#' Pay each game
#'
#' @param decision_player,decision_peer Character vectors of `"cooperate"` or
#'   `"defect"`, one element per game.
#' @param payoffs Payoffs from [set_payoffs()].
#'
#' @return The player's payoff in each game.
#' @export
#'
#' @examples
#' payoff_rule(c("cooperate", "defect"), c("defect", "defect"))
payoff_rule <- function(decision_player, decision_peer, payoffs = set_payoffs()) {
  case_when(
    decision_player == "cooperate" & decision_peer == "cooperate" ~ payoffs[["reward"]],
    decision_player == "cooperate" & decision_peer == "defect"    ~ payoffs[["sucker"]],
    decision_player == "defect"    & decision_peer == "cooperate" ~ payoffs[["temptation"]],
    decision_player == "defect"    & decision_peer == "defect"    ~ payoffs[["punishment"]],
    TRUE ~ NA_real_
  )
}
