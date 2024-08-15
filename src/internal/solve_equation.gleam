import gleam/float
import gleam/io
import gleam/list
import gleam/order
import gleam/result
import internal/convert_to_monomials.{type MonomialType}

fn compute_delta(a: Float, b: Float, c: Float) {
  { b *. b } -. { 4.0 *. a *. c }
}

pub fn solve_equation(equation: List(MonomialType)) -> Result(Nil, String) {
  let print_float = fn(f: Float) { f |> float.to_string |> io.println }
  let negate_and_print = fn(f: Float) { f |> float.negate |> print_float }
  let get_position = fn(
    l: List(MonomialType),
    position: fn(List(MonomialType)) -> Result(MonomialType, Nil),
  ) {
    l
    |> position
    |> result.map(fn(m) { m.coefficient })
    |> result.unwrap(0.0)
  }
  let is_zero = fn(f: Float) { float.compare(f, 0.0) == order.Eq }
  let sqrt = fn(f) { f |> float.square_root |> result.unwrap(-42.0) }

  let degree =
    equation
    |> list.filter(fn(m) { m.coefficient |> float.compare(0.0) != order.Eq })
    |> fn(l: List(MonomialType)) {
      case l {
        [] -> 0
        _ -> {
          l
          |> list.last
          |> result.map(fn(m) { m.degree })
          |> result.unwrap(-42)
        }
      }
    }
  case degree {
    degree if degree > 2 ->
      io.println(
        "The polynomial degree is strictly greater than 2, I can't solve.",
      )
    2 -> {
      let c = equation |> get_position(list.first)
      let b = equation |> list.drop(1) |> get_position(list.first)
      let a = equation |> get_position(list.last)
      let delta = compute_delta(a, b, c)
      let is_delta_zero = is_zero(delta)
      let is_delta_lt_zero = float.compare(delta, 0.0) == order.Lt
      let is_a_zero = is_zero(a)
      let is_b_zero = is_zero(b)
      let is_c_zero = is_zero(c)
      case delta {
        _ if is_a_zero && is_b_zero && is_c_zero ->
          io.println("Any value can solve this equation.")
        _ if is_a_zero && is_b_zero -> {
          io.println("The equation is a constant:")
          c |> print_float
        }
        _ if is_delta_zero -> {
          io.println("Discrimant is 0. Only one answer is possible:")
          { b /. { 2.0 *. a } } |> negate_and_print
        }
        _ if is_delta_lt_zero -> {
          io.println(
            "Discriminant is strictly negative, the two complex solutions are:",
          )
          let sqrt = delta |> float.negate |> sqrt
          {
            { { b +. sqrt } /. a } |> float.negate |> float.to_string <> " * i"
          }
          |> io.println
          {
            { { b -. sqrt } /. a } |> float.negate |> float.to_string <> " * i"
          }
          |> io.println
        }
        _ -> {
          io.println(
            "Discriminant is strictly positive, the two solutions are:",
          )
          let a = 2.0 *. a
          { { b +. sqrt(delta) } /. a } |> negate_and_print
          { { b -. sqrt(delta) } /. a } |> negate_and_print
        }
      }
    }
    1 -> {
      let a = equation |> get_position(list.last)
      let b = equation |> get_position(list.first)
      let is_a_zero = is_zero(a)
      let is_b_zero = is_zero(b)
      case a {
        _ if is_a_zero && is_b_zero ->
          io.println("Any value can solve this equation.")
        _ if is_a_zero -> {
          io.println("The equation is a constant:")
          b |> print_float
        }
        _ -> {
          io.println("The only solution possible is:")
          { b /. a } |> negate_and_print
        }
      }
    }
    0 -> {
      let c = equation |> get_position(list.first)
      let is_c_zero = is_zero(c)
      case c {
        _ if is_c_zero -> io.println("Any value can solve this equation.")
        _ -> {
          io.println("The equation is a constant:")
          c |> print_float
        }
      }
    }
    _ ->
      io.println(
        "The polynomial degree is strictly less than 0, I can't solve it.",
      )
  }
  |> Ok
}
