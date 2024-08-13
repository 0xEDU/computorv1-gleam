import gleam/float
import gleam/io
import gleam/list
import gleam/order
import gleam/result
import internal/convert_to_monomials.{type MonomialType}

fn compute_delta(a: Float, b: Float, c: Float) {
  let delta = { b *. b } -. { 4.0 *. a *. c }
  let is_not_negative = float.compare(delta, 0.0) != order.Lt
  case is_not_negative {
    True -> Ok(delta)
    False -> Error("Discriminant is negative, can't compute complex roots!")
  }
}

pub fn solve_equation(
  equation: List(MonomialType),
) -> Result(List(MonomialType), String) {
  let degree =
    equation
    |> list.filter(fn(m) { m.coefficient |> float.compare(0.0) != order.Eq })
    |> list.last
    |> result.map(fn(m) { m.degree })
    |> result.unwrap(-42)
  case degree {
    degree if degree > 2 ->
      Error("The polynomial degree is strictly greater than 2, I can't solve.")
    2 -> {
      let get_position = fn(
        l: List(MonomialType),
        position: fn(List(MonomialType)) -> Result(MonomialType, Nil),
      ) {
        l
        |> position
        |> result.map(fn(m) { m.coefficient })
        |> result.unwrap(0.0)
      }
      let c = equation |> get_position(list.first)
      let b = equation |> list.drop(1) |> get_position(list.first)
      let a = equation |> get_position(list.last)
      let delta = compute_delta(a, b, c)
      case delta {
        Error(err) -> Error(err)
        Ok(delta) ->
          Ok({
            let is_zero = float.compare(delta, 0.0) == order.Eq
            case delta {
              _ if is_zero -> {
                io.println("Discrimant is 0. Only one answer is possible:")
                { b /. { 2.0 *. a } }
                |> float.negate
                |> float.to_string
                |> io.println
                equation
              }
              _ -> {
                let sqrt = fn(f) {
                  f |> float.square_root |> result.unwrap(-42.0)
                }
                io.println(
                  "Discriminant is strictly positive, the two solutions are:",
                )
                { { b +. sqrt(delta) } /. { 2.0 *. a } }
                |> float.negate
                |> float.to_string
                |> io.println
                { { b -. sqrt(delta) } /. { 2.0 *. a } }
                |> float.negate
                |> float.to_string
                |> io.println
                equation
              }
            }
          })
      }
    }
    1 -> Ok(equation)
    _ ->
      Error(
        "The polynomial degree is strictly less than or equal 0, I can't solve it yet.",
      )
  }
}
