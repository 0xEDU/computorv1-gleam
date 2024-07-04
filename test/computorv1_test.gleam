import gleeunit
import gleeunit/should
import internal/parse_argument.{parse_argument}
import internal/tokenize.{tokenize}
import internal/utils
import internal/validate_argument.{validate_argument}
import internal/validate_tokens.{validate_tokens}
import internal/invert_sign.{invert_sign}

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
  tokenize("5*X^0+4*X^1-=9.3=*X^2")
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

pub fn validate_tokens1_test() {
  validate_tokens(["5", "4*X", "X^2", "=", "X^2"])
  |> should.be_ok
}

pub fn validate_tokens2_test() {
  validate_tokens(["5", "", "4*X", "X^2", "=", "X^2"])
  |> should.be_error
}

pub fn validate_tokens3_test() {
  validate_tokens(["5", "**", "4*X", "X^2", "=", "X^2"])
  |> should.be_error
}

pub fn validate_tokens4_test() {
  validate_tokens(["5", "XX", "4*X", "X^2", "=", "X^2"])
  |> should.be_error
}

pub fn validate_tokens5_test() {
  validate_tokens(["5", "-X", "4*X", "X^2", "=", "X^2"])
  |> should.be_ok
}

pub fn validate_tokens6_test() {
  validate_tokens(["5", "-X^2", "4*X", "X^2", "=", "X^2"])
  |> should.be_ok
}

pub fn validate_tokens7_test() {
  validate_tokens(["5", "-X^", "4*X", "X^2", "=", "X^2"])
  |> should.be_error
}

pub fn validate_tokens8_test() {
  validate_tokens(["-9.33*X", "4*X", "X^2", "=", "X^2"])
  |> should.be_ok
}

pub fn validate_tokens9_test() {
  validate_tokens(["-9.33*X*", "4*X", "X^2", "=", "X^2"])
  |> should.be_error
}

pub fn invert_sign1_test() {
  invert_sign(["-9.33*X", "4*X", "X^2", "=", "X^2"])
  |> should.equal(Ok(["-9.33*X", "4*X", "X^2", "-X^2"]))
}

pub fn invert_sign2_test() {
  invert_sign(["-9.33*X", "4*X", "X^2", "=", "X^2"])
  |> should.equal(Ok(["-9.33*X", "4*X", "X^2", "-X^2"]))
}

pub fn invert_sign3_test() {
  invert_sign(["-9.33*X*", "4*X", "X^2", "=", "X^2", "2*X^1"])
  |> should.equal(Ok(["-9.33*X", "4*X", "X^2", "-X^2", "-2*X^1"]))
}

pub fn invert_sign4_test() {
  invert_sign(["-9.33*X*", "4*X", "X^2", "=", "X^2", "-2*X^1"])
  |> should.equal(Ok(["-9.33*X", "4*X", "X^2", "-X^2", "2*X^1"]))
}