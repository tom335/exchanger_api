IO.inspect node()

IO.inspect :mnesia.create_table(:conversion, [
  disc_copies: [node()],
  # disc_copies: [node()],
  record_name: Exchanger.Conversions.Conversion,
  attributes: [
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
