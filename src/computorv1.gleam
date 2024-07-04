import argv
import gleam/io
import gleam/result
import internal/parse_argument.{parse_argument}
import internal/tokenize.{tokenize}
import internal/validate_argument.{validate_argument}
import internal/validate_tokens.{validate_tokens}
import internal/reduce_equation.{reduce_equation}

pub fn main() {
  let argument =
    validate_argument(argv.load().arguments)
    |> result.then(parse_argument)
    |> result.then(tokenize)
    |> result.then(validate_tokens)
    |> result.then(reduce_equation)
  case argument {
    Ok(a) -> a
    Error(b) -> {
      io.println(b)
      []
    }
  }
}
