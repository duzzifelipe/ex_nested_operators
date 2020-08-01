defmodule Nested.DefinitionTest do
  use ExUnit.Case
  doctest Nested

  alias Nested.Definition

  import Kernel, except: [if: 2]
  import Nested.Definition, only: [if: 2]

  test "validate single value" do
    v1 = Definition.if(2 < 3, do: true, else: false)
    v2 = Definition.if(3 < 3, do: true, else: false)

    assert v1 == true
    assert v1 == 2 < 3

    assert v2 == false
    assert v2 == 3 < 3
  end

  test "validate multiple values" do
    v1 = Definition.if(2 < 3 < 4, do: true, else: false)
    v2 = Definition.if(3 < 5 > 6, do: true, else: false)
    v3 = Definition.if(3 == 3 > 2, do: true, else: false)
    v4 = Definition.if(3 != 5 < 4, do: true, else: false)

    assert v1 == true
    assert v1 == (2 < 3 and 3 < 4)

    assert v2 == false
    assert v2 == (3 < 5 and 5 > 6)

    assert v3 == true
    assert v3 == (3 == 3 and 3 > 2)

    assert v4 == false
    assert v4 == (3 != 5 and 5 < 4)
  end
end
