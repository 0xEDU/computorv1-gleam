pub type SecondDegreeEquation {
  SecondDegreeEquation(a: Int, b: Int, c: Int)
}

pub type ParsingError {
  InvalidEquationError
  GenericError
}

pub fn parse_argument(
  argument: String,
) -> Result(SecondDegreeEquation, ParsingError) {
  Error(InvalidEquationError)
}
