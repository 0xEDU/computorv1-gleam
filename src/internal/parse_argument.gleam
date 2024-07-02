import gleam/string
import gleam/int
import internal/utils

pub type SecondDegreeEquation {
  SecondDegreeEquation(a: Int, b: Int, c: Int)
}

pub type ParsingError {
  InvalidCharError
  EmptyStringError
  GenericError
}

fn is_num(c: String) -> Bool {
  let res = int.base_parse(c, 10)
  case res {
    Ok(_) -> True
    _ -> False
  }
}

fn is_valid_char(c: String) -> Bool {
  case c {
    "X" | "*" | "/" | "+" | "-" | "." | "^" | "=" -> True
    _ -> is_num(c)
  }
}

fn has_invalid_chars(argument: String) -> Result(Nil, ParsingError) {
  let valid = case string.to_graphemes(argument) {
    [first, ..] -> is_valid_char(first)
    [] -> True
  }
  let len = string.length(argument)
  case valid {
    True if len != 0 -> has_invalid_chars(string.drop_left(argument, 1))
    True -> Ok(Nil)
    False -> Error(InvalidCharError)
  }
}

pub fn parse_argument(
  argument: String,
) -> Result(SecondDegreeEquation, ParsingError) {
  let argument = utils.strip_whitespaces(argument)
  let res = has_invalid_chars(argument)

  case res {
    Error(e) -> Error(e)
    _ -> Ok(SecondDegreeEquation(0, 0, 0))
  }
}
