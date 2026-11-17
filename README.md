# dilemma

Prisoner's dilemma games on networks, in R.

Players sit on a network. Each round they play the game with every peer,
score their payoffs, and copy their best-scoring peer if their peers did
better. The package asks one question: when does cooperation survive?

## Install

```r
# install.packages("pak")
pak::pak("bennour007/dilemma")
```

## Example

```r
library(dilemma)
library(tidygraph)

set.seed(1)
network <- play_smallworld(n_dim = 1, dim_size = 24, order = 2, p_rewire = 0.1)

simulate_game(network, prop_defect = 0.25, rule = "mean", n_rounds = 50)
```

This returns one row per round with the share of defectors. Set
`detail = TRUE` for one row per player per round.

## What you can change

| Argument | What it does |
|---|---|
| `network` | Any `igraph` or `tidygraph` network. `one_peer()` gives each player a single peer. |
| `prop_defect` | Share of players who defect at the start. |
| `rule` | How players judge success: `"mean"`, `"median"`, `"sum"`, or `"random"` (compare with one random peer). |
| `payoffs` | The four payoffs, from `set_payoffs()`. |
| `n_rounds` | Rounds to play. A run stops early once nothing can change. |

## Building blocks

`set_payoffs()`, `payoff_rule()`, `assign_decisions()`, `peers_from_graph()`
and `play_round()` are exported, so you can run a game one round at a time.

## Read more

[The prisoner's dilemma on networks](https://bennour.xyz/projects/dilemma/)

## License

MIT
