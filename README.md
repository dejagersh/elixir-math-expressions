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
Expression.new(2, :times, :x) |> IO.puts
(2 * x)
:ok
```

Representing `2*cos(x^2)`
```
Expression.new(2, :times, Expression.new(:cos, Expression.new(:x, :raised_to, 2))) |> IO.puts
(2 * cos((x ^ 2)))
:ok
```
