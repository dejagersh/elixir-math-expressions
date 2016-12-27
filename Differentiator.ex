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
        if f == :e do # base number is E
          Expression.new(%Expression{identifier: :raised_to, type: :operator, args: [:e, g]}, :times, gprime)

        end
    end
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
