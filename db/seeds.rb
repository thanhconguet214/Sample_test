User.create! name: "Thanh Cong",
  email: "thanhcong.uet9@gmail.com",
  password: "cong123456",
  password_confirmation: "cong123456",
  admin: true,
  activated: true,
  activated_at: Time.zone.now

99.times do |n|
  name  = FFaker::Name.name
  email = "thanhcong.uet97#{n+1}@gmail.com"
  password = "password"
  User.create! name: name,
    email: email,
    password: password,
    password_confirmation: password,
    activated: true,
    activated_at: Time.zone.now
end
