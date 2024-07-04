import gleam/result
import gleam/list

pub fn invert_sign(tokens: List(String)) -> Result(List(String), String) {
	tokens
	|> list.filter(fn(token) { token != "=" })
	|> Ok
}