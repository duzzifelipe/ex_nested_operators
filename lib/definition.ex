defmodule Nested.Definition do
  @moduledoc """
  """

  @signals ~w/> < == != <= >=/a

  defmacro __using__(_args) do
    quote do
      import Kernel, except: [if: 2]
      import Nested.Definition, only: [if: 2]
    end
  end

  defmacro if(condition, clauses) do
    build_if(condition, clauses)
  end

  defp build_if(condition, do: do_clause) do
    build_if(condition, do: do_clause, else: nil)
  end

  defp build_if(condition, do: do_clause, else: else_clause) do
    final_result =
      condition
      |> decode_ast()
      |> Enum.reduce_while(true, fn {signal, left, right}, _acc ->
        result = apply(:erlang, rewrite_operator(signal), [left, right])

        Kernel.if result do
          {:cont, result}
        else
          {:halt, result}
        end
      end)

    quote do
      if unquote(final_result) do
        unquote(do_clause)
      else
        unquote(else_clause)
      end
    end
  end

  defp decode_ast({signal, _context, [left_arg, right_arg]})
       when is_tuple(left_arg) and signal in @signals do
    {_signal, _context, [_left_arg, real_left_arg]} = left_arg
    decode_ast(left_arg) ++ [{signal, real_left_arg, right_arg}]
  end

  defp decode_ast({signal, _context, [left_arg, right_arg]})
       when is_tuple(right_arg) and signal in @signals do
    {_signal, _context, [real_right_arg, _left_arg]} = right_arg
    [{signal, left_arg, real_right_arg}] ++ decode_ast(right_arg)
  end

  defp decode_ast({signal, _context, [left_arg, right_arg]}) when signal in @signals do
    [{signal, left_arg, right_arg}]
  end

  defp rewrite_operator(:!=), do: :"/="
  defp rewrite_operator(op), do: op
end
