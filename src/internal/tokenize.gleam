import gleam/list
import gleam/string

pub fn tokenize(expression: String) -> Result(List(String), String) {
  let split_equal = string.split(expression, "=")
  let len = list.length(split_equal)
  case split_equal {
    [_, _, ..] if len > 2 -> Error("InvalidExpressionError")
    [first, second, ..] -> {
      let first = string.replace(first, "-", "+-") |> string.split("+")
      let first = case first {
        ["", ..] -> first |> list.drop(1)
        _ -> first
      }
      let second = string.replace(second, "-", "+-") |> string.split("+")
      let second = case second {
        ["", ..] -> second |> list.drop(1)
        _ -> second
      }
      [first, ["="], second] |> list.flatten |> Ok
    }
    _ -> Error("InvalidExpressionError")
  }
}
