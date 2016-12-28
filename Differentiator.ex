defmodule Expression.Differentiator do
  def compute_derivative(%Expression{identifier: identifier, type: :operator, args: [f, g]}, respect_to) do
    fprime = compute_derivative(f, respect_to)
    gprime = compute_derivative(g, respect_to)

    case identifier do
      # (f+g)' = f' + g'
      :plus -> Expression.new(fprime, :plus, gprime)

      # (f-g)' = f' - g'
      :minus -> Expression.new(fprime, :minus, gprime)

      # (f*g)' = f' * g + f  * g'
      :times -> Expression.new(Expression.new(fprime, :times, g), :plus, Expression.new(f, :times, gprime))

      # (f/g)' = (f' * g - g' * f) / (g^2)
      :divided_by ->
        numerator = Expression.new(Expression.new(fprime, :times, g), :minus, Expression.new(gprime, :times, f))
        denominator = Expression.new(g, :raised_to, 2)
        Expression.new(numerator, :divided_by, denominator)

      :raised_to ->
        cond do

          # (e^u)' = e(u) * u'
          f == :e -> Expression.new(Expression.new(:e, :raised_to, g), :times, gprime)

          # (a^u)' = a^u * ln(a) * u'
          !Expression.contains_variable?(f, respect_to) -> Expression.new(Expression.new(Expression.new(f, :raised_to, g), :times, Expression.new(:log, f)), :times, gprime)

          # (u^a) = a * u ^ (a-1) * u'
          # u = f
          # a = g
          Expression.contains_variable?(f, respect_to) and !Expression.contains_variable?(g, respect_to) -> Expression.new(Expression.new(g, :times, Expression.new(f, :raised_to, Expression.new(g, :minus, 1))), :times, fprime)

          true -> raise ArgumentError, message: "Sorry, cannot compute derivate of this expression."
        end
    end
  end

  def compute_derivative(%Expression{identifier: identifier, type: :function, args: [g]}, respect_to) do
    gprime = compute_derivative(g, respect_to)

    lhs =
      case identifier do

        # (cos(u))' = -sin(u) * u'
        :cos    -> Expression.new(-1, :times, Expression.new(:sin, g))

        # (sin(u))' = cos(u) * u'
        :sin    -> Expression.new(:cos, g)

        :tan    -> Expression.new(1, :divided_by, Expression.new(Expression.new(:cos, g), :times, Expression.new(:cos, g)))

        # (ln(u)) = (1/u) * u'
        :log    -> Expression.new(Expression.new(1, :divided_by, g), :times, gprime)

        # (log10(u))' = (ln(u)/ln(10))' = (1/u) * (1/ln(10)) * u'
        :log10  -> Expression.new(Expression.new(Expression.new(1, :divided_by, g), :times, 1/:math.log(10)), :times, gprime)

        # (log2(u))' = (ln(u)/ln(2))' = (1/u) * (1/ln(2)) * u'
        :log2  -> Expression.new(Expression.new(Expression.new(1, :divided_by, g), :times, 1/:math.log(2)), :times, gprime)

        _ -> raise InvalidArgument, message: "Sorry, we can not compute the derivative of the function '" <> identifier <> "'."
      end

    # Apply chain rule
    Expression.new(lhs, :times, gprime)
  end

  def compute_derivative(var, respect_to) when is_atom(var) do
    if(var == respect_to) do
      1
    else
      0
    end
  end

  def compute_derivative(k, _respect_to) when is_number(k) do
    0
  end

  def compute_nth_derivative(exp, _respect_to, n) when n==0 do
    exp
  end

  def compute_nth_derivative(exp, respect_to, n) when n>0 do
    compute_derivative(exp, respect_to)
    |> Expression.Simplifier.simplify
    |> compute_nth_derivative(respect_to, n-1)
  end
end
