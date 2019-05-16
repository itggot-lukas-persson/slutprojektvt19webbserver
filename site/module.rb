def homepage 
    db = SQLite3::Database.new("db/forum.db")
    db.results_as_hash = true
    if session[:user_id]
        current_user = db.execute("SELECT username, password FROM users WHERE id = ?",session[:user_id]).first
    else 
        current_user = nil
    end
    posts = db.execute("SELECT * FROM posts").reverse
    users = db.execute("SELECT * FROM users")
    return [current_user, posts, users]
end

def comment(params)
    db = SQLite3::Database.new("db/forum.db")
    db.results_as_hash = true
    db.execute('INSERT INTO comments(comment, user_id) VALUES ((?), (?))', [params[:post], session[:user_id]])
end

def register(params)
    db = SQLite3::Database.new("db/forum.db")
    db.results_as_hash = true
    hash_passsword = BCrypt::Password.create(params[:password])
    db.execute('INSERT INTO users(username, email, password) VALUES ((?), (?), (?))', params[:username], params[:email], hash_passsword)
end

def newpost(params)
    db = SQLite3::Database.new("db/forum.db")
    db.results_as_hash = true
    db.execute('INSERT INTO posts(text, user_id) VALUES ((?), (?))', [params[:post], session[:user_id]])
end

def newlogin(params)
    db = SQLite3::Database.new("db/forum.db")
    db.results_as_hash = true
    result = db.execute("SELECT id, username, password FROM users WHERE username = ?",params[:username]).first
    return [result]
end    