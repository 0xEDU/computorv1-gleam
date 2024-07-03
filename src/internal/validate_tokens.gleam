import gleam/list
import gleam/result

fn is_empty_token(token: String) -> Result(String, String) {
  case token {
    "" -> Error("Invalid token")
    _ -> Ok(token)
  }
}

pub fn validate_tokens(tokens: List(String)) -> Result(List(String), String) {
  Ok(tokens)
  |> result.try(fn(tokens) { list.try_map(tokens, is_empty_token) })
  // |> result.try(fn(tokens) { list.try_map(tokens, '')})
}
