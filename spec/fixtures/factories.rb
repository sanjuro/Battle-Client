FactoryGirl.define do
  factory :game do
    server_game_id     1000
    name               'shadley'
    email              'shad6ster@gmail.com'
  end
  
  factory :ship do
    id                 1
    name               'battleship'
    length             5
    max_per_game       1
  end

end