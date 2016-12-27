# Building Expressions 

## Supported operators
- `:plus`
- `:minus`
- `:times`
- `:divided_by`
- `:raised_to`

## Supported functions
- `:log10`
- `:log`
- `:log2`
- `:cos`
- `:sin`
- `:tan`

## Supported constants
- `:e`
- `:pi`
The atom `:e` represents Euler's number. `:pi` represents the mathemetical constant π.

## Examples

Representing `2x`
```
iex> Expression.new(2, :times, :x) |> IO.puts
(2 * x)
:ok
```

Representing `2*cos(x^2)`
```
iex> Expression.new(2, :times, Expression.new(:cos, Expression.new(:x, :raised_to, 2))) |> IO.puts
(2 * cos((x ^ 2)))
:ok
```

# Simplifying expressions
The `Expression.Simplifier` module allows for basic simplifications like `0 * x => x`, `x^1 => x`. As of now, expressions like `2x + x` don't get simplified to `3x`.

## Examples
Simplifying `1^1^1`:
```
iex> Expression.new(1, :raised_to, Expression.new(1, :raised_to, 1)) |> Expression.Simplifier.simplify |> IO.puts
1.0
:ok
```
