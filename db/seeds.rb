User.create! name: "Thanh Cong",
  email: "congmu.cyn@gmail.com",
  password: "cong123456",
  password_confirmation: "cong123456",
  admin: true,
  activated: true,
  activated_at: Time.zone.now

99.times do |n|
  name  = FFaker::Name.name
  email = "congmu.cyn#{n+1}@gmail.com"
  password = "password"
  User.create! name: name,
    email: email,
    password: password,
    password_confirmation: password,
    activated: true,
    activated_at: Time.zone.now
end

users = User.order(:created_at).take(6)
50.times do
  content = FFaker::Lorem.sentence(5)
  users.each {|user| user.microposts.create!(content: content)}
end
