require 'sinatra'
require 'slim'
require 'sqlite3'
require 'bcrypt'
enable :sessions

get('/') do
    db = SQLite3::Database.new("db/forum.db")
    db.results_as_hash = true
    if session[:user_id]
        current_user = db.execute("SELECT username, password FROM users WHERE id = ?",session[:user_id]).first
    else 
        current_user = nil
    end
    posts = db.execute("SELECT * FROM posts").reverse
    users = db.execute("SELECT * FROM users")
    slim(:index, locals:{current_user:current_user, posts:posts, users:users})
end

get('/login') do
    slim(:login)
end


post('/newlogin') do
    db = SQLite3::Database.new("db/forum.db")
    db.results_as_hash = true
    result = db.execute("SELECT id, username, password FROM users WHERE username = ?",params[:username]).first
    unless result
        redirect('/error')
    else BCrypt::Password.new(result["password"]) == params[:password]
        session[:user_id] = result["id"]
        redirect('/')
    end
end

get('/register') do
    slim(:register)
end

post('/register') do
    db = SQLite3::Database.new("db/forum.db")
    db.results_as_hash = true
    hash_passsword = BCrypt::Password.create(params[:password])
    db.execute('INSERT INTO users(username, email, password) VALUES ((?), (?), (?))', params[:username], params[:email], hash_passsword)
    redirect('/') 
end


get('/newpost') do 
    if !session[:user_id] #Kollar att man är inloggad innan man får komma in på sidan
        redirect back
    end
    slim(:newpost)
end

post('/newpost') do
    db = SQLite3::Database.new("db/forum.db")
    db.results_as_hash = true
    db.execute('INSERT INTO posts(text, user_id) VALUES ((?), (?))', [params[:post], session[:user_id]])
    redirect('/')
end

get('/error') do
    slim(:error)
end

post('/logout') do
    session.destroy
    redirect("/")
end