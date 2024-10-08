import argv
import gleam/io
import gleam/result
import internal/convert_to_monomials.{convert_to_monomials}
import internal/invert_sign.{invert_sign}
import internal/parse_argument.{parse_argument}
import internal/print_equation_details.{print_equation_details}
import internal/reduce_equation.{reduce_equation}
import internal/solve_equation.{solve_equation}
import internal/tokenize.{tokenize}
import internal/validate_argument.{validate_argument}
import internal/validate_equation.{validate_equation}
import internal/validate_tokens.{validate_tokens}

pub fn main() {
  let argument =
    argv.load().arguments
    |> validate_argument
    |> result.then(parse_argument)
    |> result.then(tokenize)
    |> result.then(validate_tokens)
    |> result.then(invert_sign)
    |> result.then(convert_to_monomials)
    |> result.then(reduce_equation)
    |> result.then(print_equation_details)
    |> result.then(validate_equation)
    |> result.then(solve_equation)
  case argument {
    Ok(a) -> a
    Error(b) -> {
      io.println(b)
    }
  }
}
