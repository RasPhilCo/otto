```bash
$ git clone https://url/to/repo
$ cd otto
$ bundle install

# make app
$ ruby otto.rb

# seed db
$ ruby db/seeds.rb  

# (make sure mongo is running)
# start server
$ ruby app.rb  

# in another tab/window
$ curl localhost:4567/hi
$ curl localhost:4567/facts
```
