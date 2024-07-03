import gleam/int
import gleam/string
import internal/utils

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

fn has_invalid_chars(argument: String) -> Result(Nil, String) {
  let valid = case string.to_graphemes(argument) {
    [first, ..] -> is_valid_char(first)
    [] -> True
  }
  let len = string.length(argument)
  case valid {
    True if len != 0 -> has_invalid_chars(string.drop_left(argument, 1))
    True -> Ok(Nil)
    False -> Error("InvalidCharError")
  }
}

pub fn parse_argument(argument: String) -> Result(String, String) {
  let argument = utils.strip_whitespaces(argument)
  let res = has_invalid_chars(argument)

  case res {
    Error(e) -> Error(e)
    _ -> Ok(argument)
  }
}
