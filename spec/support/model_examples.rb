shared_examples_for "has a valid test factory" do |model_factory,model_class|
  # e.g.
  # it_behaves_like "has a valid test factory", :report, Report
  describe ':#{model_factory} factory' do
    subject { Factory(model_factory) }
    it { should be_valid }
    it { should be_a(model_class) }
  end
end

shared_examples_for "having associations" do |model_class,associations|
  # e.g.
  # it_behaves_like "having associations", Report, {:provider_org=>:belongs_to, :report_category=>:belongs_to}
  context "#{model_class.class.name} associations [#7346087]" do
    subject { model_class }
    associations.each do |association,macro|
      it "#{association} should be a #{macro}" do
        subject.reflect_on_association(association).macro.should eql(macro)
      end
    end
  end
end
