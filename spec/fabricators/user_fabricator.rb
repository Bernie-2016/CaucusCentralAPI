Fabricator(:user) do
  first_name 'Bruce'
  last_name 'Wayne'
  email { sequence(:email) { |i| "bruce#{i}@thebatcave.com" } }
  password 'aquamansuxsomuch'
  password_confirmation 'aquamansuxsomuch'
  privilege :unassigned
end

Fabricator(:captain, from: :user) do
  privilege :captain
end

Fabricator(:organizer, from: :user) do
  privilege :organizer
end
