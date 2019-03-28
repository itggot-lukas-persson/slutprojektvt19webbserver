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

get('/logged') do
    slim(:logged)
end

post('/newlogin') do
    db = SQLite3::Database.new("db/forum.db")
    db.results_as_hash = true
    result = db.execute("SELECT username, password FROM users WHERE username = ?",params[:username]).first
    if BCrypt::Password.new(result["password"]) == params[:password]
        redirect('/logged')
    else
        redirect('/error')
    end
end

get('/register') do
    slim(:register)
end

post('/register/new') do
    db = SQLite3::Database.new("db/forum.db")
    db.results_as_hash = true
    hash_passsword = BCrypt::Password.create(params[:password])
    db.execute('INSERT INTO users(username, email, password) VALUES ((?), (?), (?))', params[:username], params[:email], hash_passsword)
    redirect('/') 
end
