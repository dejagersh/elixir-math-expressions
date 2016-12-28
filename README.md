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
```

Representing `2*cos(x^2)`
```
iex> Expression.new(2, :times, Expression.new(:cos, Expression.new(:x, :raised_to, 2))) |> IO.puts
(2 * cos((x ^ 2)))
```


# Setting variables
If your expression contains variables, you can give those variables values with the `Expression.set_variable` function.


## Examples
```
iex> Expression.new(:sin, Expression.new(:x, :raised_to, 2)) |> Expression.set_variable(:x, :pi) |> IO.puts
sin((pi ^ 2))
```

# Evaluating expressions
If an expression does *not* contain any variables, the expression can be evaluated.

## Examples
```
iex> Expression.new(:sin, Expression.new(:x, :raised_to, 2)) |> Expression.set_variable(:x, :pi) |> Expression.evaluate |> IO.puts
-0.43030121700009166
```

# Simplifying expressions
The `Expression.Simplifier` module allows for basic simplifications like `0 * x => x`, `x^1 => x`. As of now, expressions like `2x + x` don't get simplified to `3x`.

## Examples
Simplifying `1^1^1`:
```
iex> Expression.new(1, :raised_to, Expression.new(1, :raised_to, 1)) |> Expression.Simplifier.simplify |> IO.puts
1.0
```
# Computing derivatives

## Examples
Computing the derivative of `cos(sin(x))` with respect to `x` and simplifying the result:

```
iex> Expression.new(:cos, Expression.new(:sin, :x)) |> Expression.Differentiator.differentiate(:x) |> Expression.Simplifier.simplify |> IO.puts
((-1 * sin(sin(x))) * cos(x))
:ok
```

# Computing Taylor/McLaurin series
The `Expression.TaylorSeries` module allows you to compute Taylor and McLaurin series of functions.

## Examples
First five terms for the McLaurin series of `sin(x)`:
```
iex> Expression.new(:sin, :x) |> Expression.TaylorSeries.compute_mclaurin_series(:x, 5) |> IO.puts
((((sin(x) + (cos(x) * x)) + (((-1 * sin(x)) / 2) * (x ^ 2))) + (((-1 * cos(x)) / 6) * (x ^ 3))) + (((-1 * (-1 * sin(x))) / 24) * (x ^ 4)))
```
