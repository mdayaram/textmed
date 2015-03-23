# Generated with RailsBricks
# Initial seed file to use with Devise User Model

# Temporary admin account
num = 14158675309
u = User.new(
  email: "admin@example.com",
  phone_number: PhonyRails.normalize_number(num.to_s),
  password: "1234",
  password_confirmation: "1234",
  admin: true
)
u.skip_confirmation!
u.save!

names = [ "Mako", "Korra", "Bolin", "Asami", "Aang", "Katara", "Toph", "Saka", "Zuko" ]
# Test user accounts
(1..50).each do |i|
  u = User.new(
    name: names[i % names.length],
    email: "user#{i}@example.com",
    phone_number: PhonyRails.normalize_number((num + i).to_s),
    password: "1234",
    password_confirmation: "1234"
  )
  u.skip_confirmation!
  u.save!

  puts "#{i} test users created..." if (i % 5 == 0)

end
