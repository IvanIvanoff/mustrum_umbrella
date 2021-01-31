defmodule MustrumTesterTest do
  use ExUnit.Case, async: true

  @tag points: 2
  test "fail" do
    assert 1 == 2
  end

  test "fail 2" do
    assert 1 == 2
  end

  @tag points: 5
  test "fail 3" do
    assert 1 == 4
  end

  test "fail 4" do
    assert 1 == 5
  end

  test "fail 6" do
    assert 1 == 5
  end

  test "fail 5" do
    assert 1 == 5
  end

  test "succeed" do
    assert 1 == 1
  end

  @tag :skip
  test "skip me" do
    assert 1 == 2
  end

  @tag :exclude
  test "excluded" do
    assert 1 == 2
  end

  @tag points: 6
  test "succeed 2" do
    assert 1 == 1
  end
end
