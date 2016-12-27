defmodule Expression.Simplifier do
  def simplify(%Expression{identifier: identifier, type: type, args: args}) do
    args = args |> Enum.map(&simplify(&1))

    case type do
      :operator ->
        lhs = Enum.at(args, 0)
        rhs = Enum.at(args, 1)

        if is_number(lhs) and is_number(rhs) do
          Expression.evaluate(Expression.new(lhs, identifier, rhs))
        else
          case identifier do
            :times ->
              cond do
                # 0 * x = 0 and x * = 0
                lhs === 0 or rhs === 0                            -> 0

                # 1 * x = x
                lhs === 1                                         -> rhs

                # x * 1 = x
                rhs === 1                                         -> lhs

                is_number(lhs) and is_number(rhs)                 -> lhs * rhs

                true -> %Expression{identifier: identifier, type: type, args: args}
              end
            :divided_by ->
              cond do
                # 0 / x = 0
                lhs == 0              -> 0

                # x / 1 = x
                rhs == 1              -> lhs

                true -> %Expression{identifier: identifier, type: type, args: args}
              end
            :plus ->
              cond do

                # 0 + x = x
                lhs == 0              -> rhs

                # x + 0 = x
                rhs == 0              -> lhs

                true -> %Expression{identifier: identifier, type: type, args: args}
              end

            :minus ->
              cond do
                rhs == 0              -> lhs

                true -> %Expression{identifier: identifier, type: type, args: args}
              end

            :raised_to ->
              cond do
                rhs === 1             -> lhs

              end

            _ -> %Expression{identifier: identifier, type: type, args: args}
          end
        end



      :function -> 9
    end
  end

  def simplify(a) do
    a
  end
end
