defmodule TaylorSeries do

  def compute_taylor_series(func, _center, _respect_to, 1) do
    func
  end

  def compute_taylor_series(func, center, respect_to, n_terms) do
    Expression.new(
      compute_taylor_series(func, center, respect_to, n_terms - 1),
      :plus,
      compute_nth_term(func, center, respect_to, n_terms-1)
    )
  end

  def compute_mclaurin_series(func, respect_to, n_terms) do
    compute_taylor_series(func, 0, respect_to, n_terms)
  end


  def compute_nth_term(func, center, respect_to, n) do
    derivative = Expression.Differentiator.compute_nth_derivative(func, respect_to, n)
    factor = Expression.new(derivative, :divided_by, factorial(n))

    Expression.new(factor, :times, Expression.new(Expression.new(:x, :minus, center), :raised_to, n))
    |> Expression.Simplifier.simplify
  end


  defp factorial(n) do
    if n==0 do
      1
    else
      n * factorial(n-1)
    end
  end
end
