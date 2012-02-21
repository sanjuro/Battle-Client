Factory.define :user do |user|
  user.id                    1
  user.name                  'Test'
  user.password              'rad6hia'
  user.email                 'test@gmail.com'
end

Factory.define :game do |game|
  game.id                1
  game.user_id           1
  game.server_game_id    1000
  game.status            'in_progress'
  game.server_hits       0
  game.player_hits       0
end

Factory.define :block do |block|
  block.game_id           1
  block.y                 0
  block.x                 0
  block.status            'hit'
  block.is_server_block   false
end