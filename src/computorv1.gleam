import argv
import gleam/io
import gleam/result
import internal/validate_argument.{validate_argument}

pub fn main() {
  let argument =
    validate_argument(argv.load().arguments)
    |> result.map_error(fn(error) {
      io.println(error)
      panic
    })
    |> result.unwrap("")
  io.println(argument)
}
