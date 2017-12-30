### Build and deploy http://jasonheppler.org

### If you want to use this file as-is, then you
### need to change the variables below to your
### own SSH user, document root, etc.
### However, you will most likely also want to
### customize the various steps (e.g. the css target)
### so that it matches the details of your own
### setup.
### 
### Apart from hugo, you will also need rsync to deploy
### the site, and the java-based yuicompressor to
### minify the CSS, should you keep that step.


SSH_USER = jasonhep@jasonheppler.org
DOCUMENT_ROOT = ~/public_html/jasonheppler/
PUBLIC_DIR = public/

all: compress site 

server: css
	hugo server --buildDrafts -ws .

deploy: compress site
	rsync -crzve 'ssh -p 22' $(PUBLIC_DIR) $(SSH_USER):$(DOCUMENT_ROOT)

compress: css
	java -jar ~/.dotfiles/bin/yuicompressor-2.4.8.jar static/css/stylesheet.css -o static/css/stylesheet-min.css --charset utf-8

site: css .FORCE
	hugo 
	find public -type d -print0 | xargs -0 chmod 755
	find public -type f -print0 | xargs -0 chmod 644

css:
	touch static/css/stylesheet.css 
	rm -f static/css/stylesheet.css
	cat static/css/kube.css static/css/custom.css static/css/syntax.css static/css/bigfoot-default.css > static/css/stylesheet.css

clean:
	rm -rf public/

.FORCE:
