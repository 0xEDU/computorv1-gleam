import gleam/result
import gleam/list

pub fn reduce_equation(tokens: List(String)) -> Result(List(String), String) {
	tokens
	|> list.filter(fn(token) { token != "=" })
	|> Ok
}