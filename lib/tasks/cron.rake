desc "Run cron task (updates show loading by default)"
task :cron => :environment do |t|
	puts "cron: Processing tasks..."
  options = { }
  options.merge!( :trace => t.application.options.trace )  if t.application.options.trace

  control = Navd::Scraper::Control.new(options)
  control.load_all_shows

	puts "cron: Done."
end