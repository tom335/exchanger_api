:mnesia.create_table(:conversion, [
  disc_copies: [node()],
  record_name: Exchanger.Conversions.Conversion,
  attributes: [
      :id,
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
    :rates,
    :updated_at,
    :inserted_at
  ],
  type: :set
])
