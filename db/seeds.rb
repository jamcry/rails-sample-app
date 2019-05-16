User.create!(name:  "Example User",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end

5.times { User.first.microposts.create!(content: Faker::Quote.famous_last_words)}

15.times do |n|
  quote_text = Faker::Quote.famous_last_words
  user_email = "example-#{n+1}@railstutorial.org"
  user = User.find_by(email: user_email)
  user.microposts.create!(content: quote_text)
end
