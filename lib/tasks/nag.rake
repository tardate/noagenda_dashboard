namespace :nag do
  desc "Load a specifc show (show=333 reload=true|false)"
  task :load => :environment do |t|
    show_number = ENV['show'].present? ? ENV['show'] : nil
    reload = ENV['reload'].present? ? (ENV['reload'] =~ /^t/i) : false
    options = { :show_number => show_number, :reload => reload }
    options.merge!( :trace => t.application.options.trace )  if t.application.options.trace

    puts "nag:load: Processing tasks..."
    control = Navd::Scraper::Control.new(options)
    control.load_show(options[:show_number],options[:reload])
  	puts "nag:load: Done."
  end
end