namespace :nag do
  desc "Load a specifc show (show=333)"
  task :load => :environment do |t|
    show_number = ENV['show'].present? ? ENV['show'] : nil
    options = { :show_number => show_number }
    options.merge!( :trace => t.application.options.trace )  if t.application.options.trace

    puts "nag:load: Processing tasks..."
    control = Navd::Scraper::Control.new(options)
    control.load_show(show_number)
  	puts "nag:load: Done."
  end
end