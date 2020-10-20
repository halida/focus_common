build:
	gem build focus_common.gemspec

upload:
	gem push *.gem

clear:
	rm *.gem
