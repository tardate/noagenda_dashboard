module MocksHelper

  def unpublished_show_page_html
    %{
<html>
	<head>
		<title>Index of /</title>
		</head>
	<body>
		<h2>Index of /</h2>
		<table cellpadding="4" width="100%" border="0">
			<tr><td>&nbsp;</td><td><b>Name</b></td><td><b>Size</b></td><td><b>Kind</b></td><td><b>Last Modified</b></td></tr>

			<tr><td colspan="5"><hr noshade></td></tr>
			<tr><td colspan="5"><hr noshade></td></tr>
			</table>
		</body>
</html>
    }
  end

end

# include automatically for models
RSpec.configure do |conf|
  conf.include MocksHelper, :type => :model
end