import gleam/list
import gleam/string

pub fn tokenize(expression: String) -> Result(List(String), String) {
  let split_equal = string.split(expression, "=")
  let len = list.length(split_equal)
  case split_equal {
    [_, _, ..] if len > 2 -> Error("Invalid expression!")
    [first, second, ..] -> {
      let splitter = fn(str) {
        str
        |> string.replace("-", "+-")
        |> string.split("+")
        |> fn(str) {
          case str {
            ["", ..] -> str |> list.drop(1)
            _ -> str
          }
        }
      }
      let first = first |> splitter
      let second = second |> splitter
      [first, ["="], second] |> list.flatten |> Ok
    }
    _ -> Error("Invalid expression!!")
  }
}
