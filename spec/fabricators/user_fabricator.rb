Fabricator(:user) do
  first_name 'Bruce'
  last_name 'Wayne'
  email { sequence(:email) { |i| "bruce#{i}@thebatcave.com" } }
  password 'aquamansuxsomuch'
  password_confirmation 'aquamansuxsomuch'
  privilege :unassigned
  invitation
  state { State.find_by(code: 'IA') }
end

Fabricator(:captain, from: :user) do
  privilege :captain
end

Fabricator(:organizer, from: :user) do
  privilege :organizer
end

Fabricator(:admin, from: :user) do
  privilege :admin
end
