FactoryBot.define do
  factory :user do
    username {"Example User"}
    email {"example@rails.org"}
    password {"abcxyz"}
    role {1}
    confirmed_at {Time.now}
  end
end
