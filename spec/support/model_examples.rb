shared_examples_for "has a valid test factory" do |model_factory,model_class|
  # e.g.
  # it_behaves_like "has a valid test factory", :report, Report
  describe ':#{model_factory} factory' do
    subject { Factory(model_factory) }
    it { should be_valid }
    it { should be_a(model_class) }
  end
end