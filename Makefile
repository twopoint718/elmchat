main = Main.elm
sources = \
	src/Api.elm \
	src/Model.elm \
	src/Types.elm \
	src/Update.elm \
	src/View.elm
cc = elm make

index.html: $(main) $(sources)
	$(cc) $(main)

run: index.html
	postgrest --db-name elmchat \
	          --db-user chris \
		  --anonymous postgres \
		  --v1schema public
