#' @keywords internal
"_PACKAGE"

#' @importFrom dplyr mutate summarise filter select bind_rows distinct
#' @importFrom dplyr case_when first n_distinct slice_sample
#' @importFrom purrr accumulate done map_dbl
#' @importFrom tibble tibble
#' @importFrom utils globalVariables
NULL

# column names used inside dplyr verbs
utils::globalVariables(c(
  "player", "peer", "decision_player", "decision_peer", "payoff_player",
  "score_player", "score_peer", "benchmark", "decision_best"
))
