require 'sinatra'
require 'slim'
require 'sqlite3'
require 'bcrypt'
enable :sessions

get('/') do
    if session[:username]
        db = SQLite3::Database.new("db/forum.db")
        current_user = db.execute("SELECT username, password FROM users WHERE username = ?",session[:username]).first
    else 
        current_user = nil
    end
    slim(:index, locals:{current_user:current_user})
end

get('/login') do
    slim(:login)
end


post('/newlogin') do
    db = SQLite3::Database.new("db/forum.db")
    db.results_as_hash = true
    result = db.execute("SELECT username, password FROM users WHERE username = ?",params[:username]).first
    unless result
        redirect('/error')
    else BCrypt::Password.new(result["password"]) == params[:password]
        session[:username] = result["username"]
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
    if !session[:username] #Kollar att man är inloggad innan man får komma in på sidan
        redirect back
    end
    slim(:newpost)
end

get('/error') do
    slim(:error)
end