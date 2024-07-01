import gleeunit
import gleeunit/should
import internal/validate_arguments.{validate_arguments}

pub fn main() {
  gleeunit.main()
}

pub fn validate_argument_wrong_size_test() {
  validate_arguments(["invalid", "size"])
  |> should.be_error()
  |> should.equal("Usage: ./computor [equation]")
}

pub fn validate_argument_correct_size_test() {
  let input = "valid size"
  validate_arguments([input])
  |> should.be_ok()
  |> should.equal(input)
}
