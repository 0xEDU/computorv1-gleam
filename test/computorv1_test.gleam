import gleeunit
import gleeunit/should
import internal/parse_argument.{type ParsingError, parse_argument}
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

pub fn parse_invalid_argument_test() {
  parse_argument("invalid")
  |> should.be_error()
  |> fn(error) {
    case error {
      parse_argument.GenericError -> success
      _ -> should.fail()
    }
  }
}
