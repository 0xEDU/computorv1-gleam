import gleeunit
import gleeunit/should
import internal/parse_argument.{type ParsingError, parse_argument}
import internal/tokenize.{tokenize}
import internal/utils.{strip_whitespaces}
import internal/validate_argument.{validate_argument}

const success = Nil

pub fn main() {
  gleeunit.main()
}

pub fn validate_argument_wrong_size_test() {
  validate_argument(["invalid", "size"])
  |> should.be_error()
  |> should.equal("Usage: ./computor [equation]")
}

pub fn validate_argument_correct_size_test() {
  let input = "valid size"
  validate_argument([input])
  |> should.be_ok()
  |> should.equal(input)
}

pub fn strip_whitespace_test() {
  utils.strip_whitespaces("a b c")
  |> should.equal("abc")
}

pub fn parse_argument_invalid_test() {
  parse_argument("invalid")
  |> should.be_error()
  |> fn(error) {
    case error {
      parse_argument.InvalidCharError -> success
      _ -> should.fail()
    }
  }
}

pub fn parse_argument_valid1_test() {
  parse_argument("X")
  |> should.be_ok()
}

pub fn parse_argument_valid2_test() {
  parse_argument("5 * X^0 + 4 * X^1 - 9.3 * X^2 = 1 * X^0")
  |> should.be_ok()
}

pub fn tokenize_invalid1_test() {
  tokenize("5*X^0+4*X^1-9.3*X^2")
  |> should.be_error
}

pub fn tokenize_invalid2_test() {
  tokenize("*^+*^-.*=^")
  |> should.be_error
}

pub fn tokenize1_test() {
  tokenize("5*X^0+4*X^1-9.3*X^2=1*X^0")
  |> should.be_ok
  |> should.equal(["5*X^0", "4*X^1", "-9.3*X^2", "=", "1*X^0"])
}

pub fn tokenize2_test() {
  tokenize("5+4*X+X^2=X^2")
  |> should.be_ok
  |> should.equal(["5", "4*X", "X^2", "=", "X^2"])
}