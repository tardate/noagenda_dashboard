require 'spec_helper'

describe Note do
  it_behaves_like "has a valid test factory", :note, Note

  it_behaves_like "having associations", Note, {
    :show             => :belongs_to,
    :meme             => :belongs_to
  }

end
