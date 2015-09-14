get '/' do
  erb :index
end

get '/login' do
  erb :login
end

# creates session for valid user
post '/sessions/create' do
  user = User.find_by_email(params[:email])
  #what happens if they entered the wrong email
  #what happens if they entered the wrong pass but right email?
    #1. check correct password
    #2.
  if user.nil?
    redirect '/login'
  elsif user.password == params[:password]
    session[:user_id] = @user_id
    redirect "/users/#{user.id}"
    #USE double quotes for all string interpolation!!!
  else
    redirect '/login'
  end
end

# renders new form for user creation
get '/users/new' do
#users = resource, where to create a new user
  erb :signup
end

# actually creates the user
post '/users/create' do
  user = User.new(params)
  if user.save
    session[:user_id] = user.id
    #session hash crete a key user_id and point it to value @user.id (some integer from the User table column id.)
    redirect "/users/#{user.id}"
    # interpolation for :id position in the redirect route
    # :id is a wildcard
  else
    redirect '/users/new'
  end
  # Post routes always have a redirect, not erb
  # print here prints to the terminal console
end

# profile page for specific user
get '/users/:id' do
  @user = User.find_by_id(params[:id])
  #this setup refers to a particular user
  erb :profile
end

get '/logout' do
  session[:user_id] = nil
  redirect '/'
end

#renders a form update/edit specific user info
get '/users/:id/edit' do
  user = User.find_by_id(params[:id])
  if session[:user_id] == user.id
    erb :edit_user
  else
    redirect "/users/#{session[:user_id]}"
  end
end

#actually changing of user information
post '/users/:id/update' do
  user = User.find_by_id(params[:id])
  user.name = params[:name] #new name
  user.save
  redirect "/users/#{user.id}"
end

#delete route
  #find by id
  #destroy by user (user.destroy)
  #redirect to index

############################
#creating nested routes

#render a new form for task for a user
get '/users/:id/tasks/new' do
  @user = User.find_by_id(params[:id])
  erb :new_tasks
end

post '/users/:id/tasks/create' do
  user = User.find_by_id(params[:id])
  task = Task.new(params)
  if task.save
    redirect "/users/#{user.id}/tasks"
  else
    redirect "/users/#{user.id}/tasks/new"
  end
end

get '/users/:id/tasks' do
  @user = User.find_by_id(params[:id])
  erb :tasks
end