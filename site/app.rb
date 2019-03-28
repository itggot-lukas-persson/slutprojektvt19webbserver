require 'sinatra'
require 'slim'
require 'sqlite3'
require 'bcrypt'
enable :sessions

get('/') do
    slim(:index)
end

get('/login') do
    slim(:login)
end

get('/register') do
    slim(:register)
end

post('/register/new') do
    db = SQLite3::Database.new("db/forum.db")
    hash_passsword = BCrypt::Password.create(params[:password])
    db.execute('INSERT INTO users(username, email, password) VALUES ((?), (?), (?))', params[:username], params[:email], hash_passsword)
    redirect('/') 
end
