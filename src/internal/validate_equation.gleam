import gleam/int
import gleam/list
import internal/convert_to_monomials.{type MonomialType}

pub fn validate_equation(
  equation: List(MonomialType),
) -> Result(List(MonomialType), String) {
  equation
  |> list.try_map(fn(monomial) {
    case monomial {
      monomial if monomial.degree >= 0 && monomial.degree < 3 -> Ok(monomial)
      _ ->
        Error(
          "Can't solve an equation with degree "
          <> int.to_string(monomial.degree),
        )
    }
  })
}
