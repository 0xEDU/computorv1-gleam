import gleam/float
import gleam/int
import gleam/io
import gleam/list
import gleam/order
import gleam/result
import gleam/string
import internal/convert_to_monomials.{type MonomialType, Monomial}

fn trim_zero(coeff_str: String) -> String {
  string.reverse(coeff_str)
  |> fn(coeff_str) {
    case coeff_str {
      "0." <> rest -> rest
      _ -> coeff_str
    }
  }
  |> string.reverse
}

fn value_sign(coeff: Float) -> String {
  case coeff {
    coeff if coeff <. 0.0 -> "-"
    _ -> "+"
  }
}

fn monomial_to_string(monomial: MonomialType) -> String {
  let degree = monomial.degree
  let coeff = monomial.coefficient
  let abs_coeff_str =
    " " <> coeff |> float.absolute_value |> float.to_string |> trim_zero
  let monomial_str = case degree {
    0 -> value_sign(coeff) <> abs_coeff_str
    1 -> value_sign(coeff) <> abs_coeff_str <> " * X"
    _ -> value_sign(coeff) <> abs_coeff_str <> " * X^" <> int.to_string(degree)
  }
  case float.compare(coeff, 0.0) {
    order.Eq -> ""
    _ -> monomial_str
  }
}

pub fn print_equation_details(
  equation: List(MonomialType),
) -> Result(List(MonomialType), String) {
  {
    "Reduced form: "
    <> equation
    |> list.map(monomial_to_string)
    |> list.filter(fn(s) { !string.is_empty(s) })
    |> string.join(" ")
    |> string.trim_left
    |> fn(equation_str) {
      case equation_str {
        "+" <> rest -> rest
        "- " <> rest -> "-" <> rest
        _ -> equation_str
      }
    }
    <> " = 0"
  }
  |> io.println
  {
    "Polynomial degree: "
    <> equation
    |> list.filter(fn(m) { m.coefficient |> float.compare(0.0) != order.Eq })
    |> list.last
    |> result.map(fn(x) { x.degree |> int.to_string })
    |> result.unwrap("")
  }
  |> io.println
  Ok(equation)
}
