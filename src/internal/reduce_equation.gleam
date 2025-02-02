import gleam/dict
import gleam/int
import gleam/list
import gleam/result
import internal/convert_to_monomials.{type MonomialType, Monomial}

fn pad_equation(equation: List(MonomialType)) {
  let max_degree =
    equation
    |> list.fold(0, fn(acc: Int, monomial: MonomialType) {
      case monomial {
        Monomial(_, degree) -> int.max(degree, acc)
      }
    })
  let all_degrees = list.range(0, max_degree)
  let monomial_map =
    equation
    |> list.map(fn(m) { #(m.degree, m) })
    |> dict.from_list

  let padded_equation =
    all_degrees
    |> list.map(fn (degree) {
      case dict.get(monomial_map, degree) {
        Ok(value) -> value
        Error(_) -> Monomial(0.0, degree)
      }
    })
  padded_equation
}

pub fn reduce_equation(
  equation: List(MonomialType),
) -> Result(List(MonomialType), String) {
  equation
  |> list.group(fn(monomial) { monomial.degree })
  |> dict.map_values(fn(_, v) {
    v
    |> list.reduce(fn(acc, monomial) {
      Monomial(
        coefficient: acc.coefficient +. monomial.coefficient,
        degree: acc.degree,
      )
    })
  })
  |> dict.to_list
  |> list.map(fn(tuple) { tuple.1 })
  |> list.map(fn(result) { result.unwrap(result, Monomial(0.0, 0)) })
  |> pad_equation
  |> Ok
}
