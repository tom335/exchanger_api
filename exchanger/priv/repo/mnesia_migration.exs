:mnesia.create_table(:conversion, [
  disc_copies: [node()],
  record_name: Exchanger.Conversions.Conversion,
  attributes: [
      :id,    # the ID must be included to avoid :bad_query errors
      :user_id,
      :from,
      :to,
      :rate,
      :amount,
      :amount_conv,
      :updated_at,
      :inserted_at
  ],
  type: :set
])

:mnesia.create_table(:rates, [
  disc_copies: [node()],
  record_name: Exchanger.Conversions.Rates,
  attributes: [
    :id,
    :base,
    :rates,
    :updated_at,
    :inserted_at
  ],
  type: :set
])
