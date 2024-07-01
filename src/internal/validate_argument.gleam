
pub fn validate_argument(arguments: List(String)) -> Result(String, String) {
  case arguments {
    [input] -> Ok(input)
    _ -> Error("Usage: ./computor [equation]")
  }
}
