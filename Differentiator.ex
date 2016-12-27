defmodule Expression.Differentiator do
  def differentiate(%Expression{identifier: identifier, type: :operator, args: [f, g]}, respect_to) do
    fprime = differentiate(f, respect_to)
    gprime = differentiate(g, respect_to)

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

  def differentiate(%Expression{identifier: identifier, type: :function, args: [g]}, respect_to) do
    gprime = differentiate(g, respect_to)

    lhs =
      case identifier do
        :cos -> Expression.new(-1, :times, Expression.new(:sin, g))
        :sin -> Expression.new(:cos, g)
      end

    Expression.new(lhs, :times, gprime)
  end

  def differentiate(var, respect_to) when is_atom(var) do
    if(var == respect_to) do
      1
    else
      0
    end
  end

  def differentiate(k, _respect_to) when is_number(k) do
    0
  end
end
