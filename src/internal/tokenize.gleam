import gleam/io
import gleam/list
import gleam/string

pub type TokenizeError {
  InvalidExpressionError
}

pub fn tokenize(expression: String) -> Result(List(String), TokenizeError) {
  let split_equal = string.split(expression, "=")
  let len = list.length(split_equal)
  case split_equal {
    [_, _, ..] if len > 2 -> Error(InvalidExpressionError)
    [first, second, ..] -> {
      let first = string.replace(first, "-", "+-") |> string.split("+")
      let second = string.replace(second, "-", "+-") |> string.split("+")
      [first, ["="], second] |> list.flatten |> Ok
    }
    _ -> Error(InvalidExpressionError)
  }
}