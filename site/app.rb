require 'sinatra'
require 'slim'
require 'sqlite3'
require 'bcrypt'
enable :sessions
require_relative "module"

get('/') do
    items = homepage()
    users = items[2]
    posts = items[1]
    current_user = items[0]
    slim(:index, locals:{current_user:current_user, posts:posts, users:users})
end

get('/comment') do
    slim(:comment)
end

post('/comment') do
    comment(params)
    redirect('/')
end

get('/login') do
    slim(:login)
end

post('/newlogin') do
    item = newlogin(params)
    result = item[0] 
    if result == nil
        redirect('/error')
    end
    if BCrypt::Password.new(result["password"]) == params["password"]
        session[:user_id] = result["id"]
        redirect('/')
    else
        redirect('/error')
    end
end

get('/register') do
    slim(:register)
end

post('/register') do
    register(params)
    redirect('/') 
end


get('/newpost') do 
    if !session[:user_id] #Kollar att man är inloggad innan man får komma in på sidan
        redirect back
    end
    slim(:newpost)
end

post('/newpost') do
    newpost(params)
    redirect('/')
end

get('/error') do
    slim(:error)
end

post('/logout') do
    session.destroy
    redirect("/")
end