puts "Creating users..."
normal_user = User.create!(email: "user@blinkist", password: "password")
anonymous_user = User.create!(email: "anonymous@blinkist", password: "password")

puts "Creating posts..."
posts = 5000.times.flat_map do |i|
  [
    { name: "Post #{i}", content: "Content #{i}", user_id: normal_user.id },
    { name: "Post #{5000 + i}", content: "Content #{5000 + i}", user_id: anonymous_user.id }
  ]
end
Post.insert_all(posts)
