Fabricator(:invitation) do
  email { sequence(:email) { |i| "robin#{i}@thebatcave.com" } }
end
