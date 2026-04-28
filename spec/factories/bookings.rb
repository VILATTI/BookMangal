FactoryBot.define do
  factory :booking do
    user
    date       { Date.current + 1.day }
    start_time { "12:00" }
    end_time   { "15:00" }
    notes      { Faker::Lorem.sentence }
    status     { :confirmed }

    trait :cancelled do
      status { :cancelled }
    end

    trait :today do
      date { Date.current }
    end

    trait :past do
      date { Date.current - 1.day }
    end

    trait :long do
      start_time { "10:00" }
      end_time   { "18:00" }
    end
  end
end
