import gleeunit
import gleeunit/should
import internal/basic_usage as internal

pub fn main() {
  gleeunit.main()
}

pub fn basic_usage_test() {
  internal.basic_usage()
  |> should.equal("")
}
