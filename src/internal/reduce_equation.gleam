import gleam/dict
import gleam/list
import gleam/result
import internal/convert_to_monomials.{type MonomialType, Monomial}

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
  |> Ok
}
