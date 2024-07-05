import gleam/float
import gleam/int
import gleam/io
import gleam/list
import gleam/string

const world_assertion = "something went really wrong"

pub type MonomialType {
  Monomial(coefficient: Float, degree: Int)
}

fn parse_coeff_and_degree(str: String) -> Result(MonomialType, String) {
  case string.split(str, "*X^") {
    [coeff_str, degree_str] -> {
      case string.contains(coeff_str, ".") {
        True ->
          case float.parse(coeff_str) {
            Error(_) -> Error("Invalid equation!")
            Ok(coeff) ->
              case int.parse(degree_str) {
                Error(_) -> Error("Invalid equation!")
                Ok(degree) -> Ok(Monomial(coeff, degree))
              }
          }
        False ->
          case int.parse(coeff_str) {
            Error(_) -> Error("Invalid equation!")
            Ok(coeff) ->
              case int.parse(degree_str) {
                Error(_) -> Error("Invalid equation!")
                Ok(degree) -> Ok(Monomial(int.to_float(coeff), degree))
              }
          }
      }
    }
    _ -> Error("Invalid equation!")
  }
}

fn parse_coeff(str: String) -> Result(MonomialType, String) {
  case string.split(str, "*X") {
    [coeff_str, _] -> {
      case string.contains(coeff_str, ".") {
        True ->
          case float.parse(coeff_str) {
            Error(_) -> Error("Invalid equation!")
            Ok(f) -> Ok(Monomial(f, 1))
          }
        False ->
          case int.parse(coeff_str) {
            Error(_) -> Error("Invalid equation!")
            Ok(i) -> Ok(Monomial(int.to_float(i), 1))
          }
      }
    }
    _ -> Error("Invalid equation!")
  }
}

fn parse_degree(str: String) -> Result(MonomialType, String) {
  case string.split(str, "X^") {
    [_, degree_str] -> {
      let coeff = case str {
        "-" <> _ -> -1.0
        _ -> 1.0
      }
      case int.parse(degree_str) {
        Error(_) -> Error("Invalid equation!")
        Ok(degree) -> Ok(Monomial(coeff, degree))
      }
    }
    _ -> Error("Invalid equation")
  }
}

fn parse_x(str: String) -> Result(MonomialType, String) {
  let coeff = case str {
    "-" <> _ -> -1.0
    _ -> 1.0
  }
  Ok(Monomial(coeff, 1))
}

fn parse_last(str: String) -> Result(MonomialType, String) {
  case string.contains(str, ".") {
    True ->
      case float.parse(str) {
        Error(_) -> Error("Invalid equation!")
        Ok(coeff) -> Ok(Monomial(coeff, 0))
      }
    False ->
      case int.parse(str) {
        Error(_) -> Error("Invalid equation!")
        Ok(coeff) -> Ok(Monomial(int.to_float(coeff), 0))
      }
  }
}

fn from_string(str: String) -> Result(MonomialType, String) {
  let has_coeff_and_degree = string.contains(str, "*X^")
  let has_coeff = string.contains(str, "*X")
  let has_degree = string.contains(str, "X^")
  let has_x = string.contains(str, "X")

  case str {
    _ if has_coeff_and_degree -> parse_coeff_and_degree(str)
    _ if has_coeff -> parse_coeff(str)
    _ if has_degree -> parse_degree(str)
    _ if has_x -> parse_x(str)
    _ -> parse_last(str)
  }
}

pub fn convert_to_monomials(
  tokens: List(String),
) -> Result(List(MonomialType), String) {
  tokens
  |> list.try_map(fn(token) { from_string(token) })
}
