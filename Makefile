tar: $(shell find .)
	echo $(tagname)
	mkdir happynmacos
	ls |grep -v happynmacos|xargs -I@ cp -r @ happynmacos/
	tar -zcvf happynet-macos-darwin-amd64-$(tagname).tar.gz happynmacos

clean:
	rm -rf happynmacos
