Fabricator(:user) do
  first_name 'Bruce'
  last_name 'Wayne'
  email { sequence(:email) { |i| "bruce#{i}@thebatcave.com" } }
  password 'aquamansuxsomuch'
  auth_token { sequence(:auth_token) { |i| "aquamansuxevenmorethanyouknow#{i}" } }
end

Fabricator(:confirmed_user, from: :user) do
  first_name 'Clark'
  last_name 'Kent'
  email { sequence(:email) { |i| "clark#{i}@thedailyplanet.com" } }
  password 'lexluthorisajerk'
  auth_token { sequence(:auth_token) { |i| "lexreallyisatotaljerk#{i}" } }
  confirmed_at Time.now
end
