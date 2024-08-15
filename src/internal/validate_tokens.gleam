import gleam/int
import gleam/list
import gleam/result
import gleam/string

const math_symbols = ["*", "/", "+", "-", "^"]

fn is_empty_token(token: String) -> Result(String, String) {
  case token {
    "" -> Error("Invalid token")
    _ -> Ok(token)
  }
}

fn has_number(token: String) -> Result(String, String) {
  token
  |> string.to_graphemes
  |> list.any(fn(c) {
    case int.parse(c) {
      Ok(_) -> True
      Error(_) -> False
    }
  })
  |> fn(has_error) {
    case has_error {
      True -> Ok(token)
      False ->
        case token {
          "-X^" <> rest if rest != "" -> Ok(token)
          "=" | "X" | "-X" -> Ok(token)
          _ -> Error("Invalid token")
        }
    }
  }
}

fn has_one_symbol(token: String) -> Result(String, String) {
  let token_chars = string.to_graphemes(token)
  math_symbols
  |> list.any(fn(symbol) {
    let filtered_token_chars = list.filter(token_chars, fn(c) { c == symbol })
    list.length(filtered_token_chars) > 1
  })
  |> fn(has_error) {
    case has_error {
      False -> Ok(token)
      True -> Error("Invalid token")
    }
  }
}

pub fn validate_tokens(tokens: List(String)) -> Result(List(String), String) {
  Ok(tokens)
  |> result.try(fn(tokens) { list.try_map(tokens, is_empty_token) })
  |> result.try(fn(tokens) { list.try_map(tokens, has_number) })
  |> result.try(fn(tokens) { list.try_map(tokens, has_one_symbol) })
}
