build:
	gem build focus_common.gemspec

upload: clear build
	gem push *.gem

clear:
	rm *.gem
