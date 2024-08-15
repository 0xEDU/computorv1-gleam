import gleam/list
import gleam/result

pub fn invert_sign(tokens: List(String)) -> Result(List(String), String) {
  let #(before, after) = list.split_while(tokens, fn(token) { token != "=" })
  let new_after =
    after
    |> list.rest
    |> result.unwrap([""])
    |> list.map(fn(token) {
      case token {
        "-" <> rest -> rest
        _ -> "-" <> token
      }
    })
  Ok(list.flatten([before, new_after]))
}
