# Nested

This repository is a test rewriting Python's nested comparisons in Elixir.

By design, elixir doesn't support this feature and shows the following error:

```bash
iex(1)> 1 < 2 <3
warning: Elixir does not support nested comparisons. Something like

     x < y < z

is equivalent to

     (x < y) < z

which ultimately compares z with the boolean result of (x < y). Instead, consider joining together each comparison segment with an "and", for example,

     x < y and y < z

You wrote: 1 < 2 < 3
  iex:1
```

The main idea is to decode AST tree provided to an `if` function and converts to what elixir understands (using multiple `and` operators).