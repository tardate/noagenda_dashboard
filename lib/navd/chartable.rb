module ::Navd::Chartable
  extend ActiveSupport::Concern
  

  included do
    [:to_chartable_structure].each do |method|
      delegate method, :to => self
    end
    if self <= ActionController::Base
      # expose helper methods
      [:to_chartable_structure].each do |method|
        helper_method method
      end
    end
  end

  module ClassMethods
    # +collection+ is the row-wise set of elements to chart
    #   y-label | x-label | y-value ..
    #   y-label | x-label | y-value ..
    # +options+ =
    # {
    #   template: "line_basic"
    #   ylabels: { :column => 'xxx'}
    #   yvalues: { :column => 'xxx'}
    #   xlabels: { :column => 'xxx'}
    # }
    # returns JSON structure:
    # {
    #   template: "line_basic",
    #   tooltips: {
    #     serie1: ["333", "334", "335", "336"],
    #     serie2: ["333", "334", "335", "336"]
    #   },
    #   values: {
    #     serie1: [54, 71, 46, 59], # xlabels => yvalues
    #     serie2: [93, 44, 74, 88]
    #   },
    #   labels: [333, 334, 335, 336], # ylabels
    #   legend: {
    #     serie1: "Serie 1",
    #     serie2: "Serie 2"
    #   }
    # }
    def to_chartable_structure(collection, options={})
      return unless options[:ylabels] && options[:yvalues] && options[:xlabels]
      
      data = { :template => (options[:template]||'line_basic'), :tooltips => {}, :values => {}, :labels => [], :legend => {} }

      xlabel_c = options[:xlabels][:column].to_sym
      ylabel_c = options[:ylabels][:column].to_sym
      yvalue_c = options[:yvalues][:column].to_sym
      
      xlabels = collection.collect(&xlabel_c).uniq.sort
      ylabels = collection.collect(&ylabel_c).uniq

      steps = xlabels.count

      data[:labels] = xlabels
      ylabels.each_with_index do |ylabel,index|
        data[:values][:"serie#{index + 1}"] = Array.new(steps,0)
        data[:legend][:"serie#{index + 1}"] = ylabel
      end

      collection.each do |record|
        ylabel = record[ylabel_c]
        yvalue = record[yvalue_c].to_i
        xlabel = record[xlabel_c]
        
        x_index = data[:labels].index(xlabel)
        series_name = "serie#{ylabels.index(ylabel) + 1}".to_sym
        data[:values][series_name][x_index] = yvalue
      #
      #   options[:series].each_with_index do |item, index|
      #     datum = {}
      #     item[0].each do |value_field_column,value_field_name|
      #       datum.merge!(value_field_name => to_chart_time(record[value_field_column],(value_field_column =~ /^period/)))
      #     end
      #     data[:series][index][:data] << datum
      #   end
      end
      data
    end
  end
end
