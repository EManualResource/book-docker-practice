SOURCE=./source
TMP_BOOK=./book
DEST=./dist
IGNORE=.git
EXT_LICENSE=./_license
EXT_CONFIG=./_config

default: main
	-@echo "=================="
	-@echo "  Build Success!  "
	-@echo "=================="

init:
	-rm -rf dist

pre-build:
	cp -r $(SOURCE) $(TMP_BOOK)
	rm -rf $(TMP_BOOK)/$(IGNORE)

    # create book.json
	gitbook-ext jsonmerge $(SOURCE)/book.json $(EXT_CONFIG)/book.json > $(TMP_BOOK)/book.json

build:
	gitbook build $(TMP_BOOK) $(DEST)/book
	gitbook-ext minify --verbose $(DEST)/book

package:
	cp $(TMP_BOOK)/book.json $(DEST)/book
	cp -rf $(EXT_LICENSE) $(DEST)/book/_license
	cd dist && zip -vr ./book.zip ./book/ 

	# post package
	md5 -q $(DEST)/book.zip > $(DEST)/md5

finish: 	
	# clean up
	rm -rf $(TMP_BOOK)
	
main: init pre-build build package finish
	

deploy:
	git push origin gh-pages

update-source:
	git submodule update --remote $(SOURCE)

serve:
	@echo "serve on ~> http://localhost:8000"
	cd $(DEST)/book && python -m SimpleHTTPServer 8000
	
.PHONY: default main init pre-build build package finish