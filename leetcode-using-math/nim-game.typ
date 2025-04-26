#import "template.typ": custom_template, proof, lemma
#show: custom_template.with(title: "Nim game")

#link("https://leetcode.com/problems/nim-game/description/")[
  Nim game
]

= Problem setting
You are playing a Nim game with your friend:
- Initially, there is a heap of stones on the table
- You and your friend will alternate taking turns, and *you go first*.
- On each turn, the person whose turn it is will remove 1 to 3 stones from the heap.
- The one who removes the last stone is the winner.

Given $n$, he number of stones in the heap, return _true_ if you can win the game assuming both you and your friend play optimally, otherwise return _false_.

Constraints $1 <= n <= 2^31 - 1$

= How to solve this problem
For those who don't know what a _Nim game_ is, you can take a look at #link("https://en.wikipedia.org/wiki/Nim")[Nim]

Basically, The game nim is played with heaps (or piles) of chips (or counters, beans, pebbles, matches). Players alternate in making a move, by removing some chips from one of the heaps (at least one chip, possibly the entire heap). The first player who cannot move any more loses the game @stengel2021game

Let's now call first player as $A$ and second player as $B$

Let's look at some first cases of $n$:
- $n = 1$: $A$ removes 1 stones and $B$ don't have any move => $A$ wins
- $n = 2$: $A$ removes 2 stones and $B$ don't have any move => $A$ wins
- $n = 3$: $A$ removes 3 stones and $B$ don't have any move => $A$ wins
- $n = 4$<n_4>: with any number $1 <= k <= 3$ $A$ removes, $B$ always has some stones left to moves => $B$ win. We can say this is a _losing position_ for $A$.

You may see that $n = 4$ is the first case where $A$ loses. Let's consider some more cases:
- $n = 5$: $A$ removes 1 stones and $B$ has 4 stones left, as in case $n = 4$ above, $B$ is in a _losing condition_ => $A$ wins
- $n = 6$: $A$ removes 2 stones and $B$ has 4 stones left => $A$ wins
- $n = 7$: $A$ removes 3 stones and $B$ has 4 stones left => $A$ wins
- $n = 8$: for any number $A$ moves, $B$ still can give the deadly number 4 to $A$ => $B$ wins

There is a pattern right here: a player who is in position that for every number $n >= 0$ satisfies $n equiv 0 (mod 4)$ is _losing_, else _winning_. Is that true?

#proof()[
  - Base case $n = 0$, $n equiv 0 (mod 4)$, the player loses as required.
  - Induction step:
  Assume for all $m <= n$ the rule holds:
  - if $m equiv 0 (mod 4)$, it is a losing position
  - if $m equiv 1, 2, 3 (mod 4)$, it is a winning position
  Now consider $n + 1$:
  - if $n + 1 equiv 0 (mod 4)$, then by rule, it is a losing position
  - if $n + 1 equiv 1, 2, 3 (mod 4)$:
    - the player can move by removing 1, 2, 3
    - in each case, he can choose a move to reach a number divisible by 4 (losing position for the opponent):
      - if $n + 1 equiv 1 (mod 4)$, removes 1 -> $n equiv 0 (mod 4)$
      - if $n + 1 equiv 2 (mod 4)$, removes 2 -> $n equiv 0 (mod 4)$
      - if $n + 1 equiv 3 (mod 4)$, removes 3 -> $n equiv 0 (mod 4)$
  Thus, the player can always win from $n + 1 equiv 1, 2, 3 (mod 4)$ and loses at $n equiv 0 (mod 4)$
  By induction, the theorem holds for all $n >= 0$
]

```python
class Solution:
  def canWinNim(self, n: int) -> bool:
    return n % 4 != 0
```

= Extension: Nim game with two heaps
Suppose the game is played with only two heaps and the players can remove any number of stones from a heap they choose (not restricted to the initial setup in the Leetcode question). The numbers of stones in the two heaps are called $m$ and $n$, respectively. In which positions $(m, n)$ can player $A$ win?

Let's observe a few cases:
- case $(1, 1)$: player $A$ removes 1 and $B$ removes 1. Thus $A$ loses.
- case $1, 2$:
  - player $A$ remove 1 from the second heap, game is back to case $(1, 1)$ -> $A$ is losing
  - player $A$ remove 1 from the second heap -> game is back to case $1, 1$ but for $B$ -> $A$ is winning
So if the two heaps have equal size, e.g. (1, 1), then the first player to move loses (so this is a losing position) because player $B$ can _copy_ player $A$'s move by equalising the two heaps. If the two heaps has different size, then player $A$ can equalize them by removing an approriate number of stones from the larger heap, putting $B$ in a losing position.

#lemma()[
  The nim position $m$, $n$ is winning if and only if $m != n$, otherwise losing, for all $m, n >= 0$
]

This lemma is a direct consequence of the *Sprague–Grundy theorem* for impartial games, and specifically for normal play Nim @berlekamp2001winning.
#bibliography("bibliography.bib")
