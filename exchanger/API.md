# Exchanger API

The current API provides methods for retrieving exchange rates and create conversions between currencies.


## Conversions

Endpoints aimed to create and list conversions and rates.
<br />

---
### GET /api/conversions

Returns all conversions with paginated results. It allows the following query parameters:

```
user_id
page
page_size
```
Examples:

```
/api/conversions?user_id=1          # first page of all conversions for user 1
/api/conversions?user_id=1&page=2   # second page of conversions ... and so on
```

### Response type

#### Status
`200 ok`

#### Body
```
{
    "conversions": [
        {
            "id":          Integer,
            "user_id":     Integer,
            "from":        String,
            "to":          String,
            "amount":      Float,
            "amount_conv": Float,
            "rate":        Float,
            "inserted_at": DateTime
        }
        .
        .
    ]
    "pagination": [
        "next_link":   String,
        "next_page":   Integer,
        "page":        Integer,
        "prev_page":   Integer,
        "total_count": Integer,
        "total_pages": Integer
    ]
}
```
<br />
---
### POST /api/conversions

This endpoint creates a conversion between currencies. Accepts any of
the currencies provided by the endpoint `/api/conversions/rates`.

Required fields:

<table>
  <thead>
    <tr>
        <th>Field</th>
        <th>Type</th>
        <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td><code>user_id</code></td>
        <td>Integer</td>
        <td>The user ID</td>
    </tr>
    <tr>
        <td><code>from</code></td>
        <td>Float</td>
        <td>The original currency, e.g. USD</td>
    </tr>
    <tr>
        <td><code>to</code></td>
        <td>Float</td>
        <td>The target currency</td>
    </tr>
    <tr>
        <td><code>amount</code></td>
        <td>Float</td>
        <td>The desired amount to convert from</td>
    </tr>
  </tbody>
</table>

### Response type

#### Status
`201 created`

#### Body
```
{
    "id":          Integer
    "user_id":     Integer
    "from":        String
    "to":          String
    "amount":      Float
    "amount_conv": Float
    "rate":        Float
    "inserted_at": DateTime
}
```

<br />
---
### GET /api/conversions/rates

Returns all available rates to convert currencies. Our rates
use the EUR currency as the base rate.

#### Status
`200 ok`

#### Body

```
{
  "base":   String,
  "rates":  Map
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

## Error responses

### `404 Not Found`

#### Body
```
{
    "error":   String
}
```

### `400 Bad request (malformed data)`

#### Body
```
{
    "error":   String
    "details": String
}
```

### `422 Unprocessable entity`

#### Body
```
{
    "error":   String
    "details": Map
}
```

### `415 Unsupported media type`

#### Body
```
{
    "error":   String
    "details": String
}
```
