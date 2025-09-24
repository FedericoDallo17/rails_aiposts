FactoryBot.define do
  factory :notification do
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph }
    notification_type { %w[like comment follow].sample }
    read { false }
    user
  end
end
