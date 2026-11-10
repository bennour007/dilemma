#' Starting decisions
#'
#' Shuffles a fixed number of defectors among the players.
#'
#' @param n_players Number of players.
#' @param prop_defect Share of players who start by defecting, between 0 and 1.
#'
#' @return A character vector of `"cooperate"` and `"defect"`, one per player.
#' @export
#'
#' @examples
#' assign_decisions(10, 0.2)
assign_decisions <- function(n_players, prop_defect) {
  if (prop_defect < 0 || prop_defect > 1) {
    stop("`prop_defect` must be between 0 and 1.")
  }

  n_defect <- round(n_players * prop_defect)

  sample(c(rep("cooperate", n_players - n_defect), rep("defect", n_defect)))
}
