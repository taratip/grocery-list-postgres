require "sinatra"
require "pg"
require "pry"
set :bind, '0.0.0.0'  # bind to all interfaces

configure :development do
  set :db_config, { dbname: "grocery_list_development" }
end

configure :test do
  set :db_config, { dbname: "grocery_list_test" }
end

def db_connection
  begin
    connection = PG.connect(Sinatra::Application.db_config)
    yield(connection)
  ensure
    connection.close
  end
end

FILENAME = "grocery_list.txt"

get "/" do
  redirect "/groceries"
end

get "/groceries" do
  groceries_result = []

  db_connection do |conn|
    groceries_result = conn.exec(
      'SELECT id, name FROM groceries'
    )
  end

  @groceries = groceries_result.to_a

  erb :groceries
end

get "/groceries/:id" do
  id = params[:id]

  grocery_result = []
  grocery_name = []

  db_connection do |conn|
    grocery_result = conn.exec_params(
      'SELECT g.name, c.body FROM groceries g JOIN comments c ON g.id = c.grocery_id
      WHERE g.id = $1',
      [id]
    )

    grocery_name = conn.exec_params(
      'SELECT name FROM groceries WHERE id = $1',
      [id]
    )
  end

  @name = grocery_name.to_a[0]["name"]
  @comments = grocery_result.to_a

  erb :grocery
end

post "/groceries" do
  name = params[:name]
  comment = params[:comment]

  if name.empty?
    groceries_result = []

    db_connection do |conn|
      groceries_result = conn.exec(
        'SELECT id, name FROM groceries'
      )
    end

    @groceries = groceries_result.to_a

    erb :groceries
  else
    db_connection do |conn|
      conn.exec_params(
        'INSERT INTO groceries (name) VALUES ($1)',
        [name]
      )

      if !comment.empty?
        grocery_id = conn.exec_params(
          'SELECT id FROM groceries WHERE name = $1',
          [name]
        )[0]["id"]

        conn.exec_params(
          'INSERT INTO comments (body, grocery_id) VALUES ($1, $2)',
          [comment, grocery_id]
        )
      end
    end


    redirect "/groceries"
  end
end

delete '/groceries/:id' do
  id = params[:id]

  db_connection do |conn|
    conn.exec_params(
      'DELETE FROM comments WHERE grocery_id = $1',
      [id]
    )

    conn.exec_params(
      'DELETE FROM groceries WHERE id = $1',
      [id]
    )
  end

  redirect "/"
end

get '/groceries/:id/edit' do
  @id = params[:id]
  grocery_result = []

  db_connection do |conn|
      grocery_result = conn.exec_params(
        'SELECT id, name FROM groceries WHERE id = $1',
        [@id]
      )
  end

  @name = grocery_result[0]["name"]

  erb :edit
end

patch '/groceries/:id' do
  id = params[:id]
  name = params[:name]

  if name.empty?
    redirect "/groceries/#{params[:id]}/edit"
  else
    db_connection { |conn| conn.exec_params('UPDATE groceries SET name = $1 WHERE id = $2', [name, id]) }
    redirect "/"
  end
end
