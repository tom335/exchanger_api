# Exchanger API

## /api/conversions

### GET /api/conversions

Returns all conversions with paginated results.

### POST /api/conversions

Attempts to perform a conversion between currencies. Accepts any of
the currencies provided by the endpoing `/conversions/rates`.

Required fields:

```
{
  user_id: int
  from:    string     The original currency, e.g. USD
  to:      string     The target currency
  amount:  decimal    The desired amount to convert from
}
```

### GET /api/conversions/rates

Returns all available rates to convert currencies. Our rates
use the EUR currency as the base rate.

Response type:

```
{
  base: string,
  rates: object
}
```

Response example:

```
{
  "base": "EUR"
  "rates": {
    "BRL": 6.09,
    "USD": 1.13,
    ..
  }
}
```


