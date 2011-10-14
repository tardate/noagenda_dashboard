require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe MemesController do

  # This should return the minimal set of attributes required to create a valid
  # Meme. As you add validations to Meme, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end

  describe "GET index" do
    it "assigns all memes as @memes" do
      meme = Meme.create! valid_attributes
      get :index
      assigns(:memes).should eq([meme])
    end
  end

  describe "GET show" do
    it "assigns the requested meme as @meme" do
      meme = Meme.create! valid_attributes
      get :show, :id => meme.id.to_s
      assigns(:meme).should eq(meme)
    end
  end

  describe "GET new" do
    it "assigns a new meme as @meme" do
      get :new
      assigns(:meme).should be_a_new(Meme)
    end
  end

  describe "GET edit" do
    it "assigns the requested meme as @meme" do
      meme = Meme.create! valid_attributes
      get :edit, :id => meme.id.to_s
      assigns(:meme).should eq(meme)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Meme" do
        expect {
          post :create, :meme => valid_attributes
        }.to change(Meme, :count).by(1)
      end

      it "assigns a newly created meme as @meme" do
        post :create, :meme => valid_attributes
        assigns(:meme).should be_a(Meme)
        assigns(:meme).should be_persisted
      end

      it "redirects to the created meme" do
        post :create, :meme => valid_attributes
        response.should redirect_to(Meme.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved meme as @meme" do
        # Trigger the behavior that occurs when invalid params are submitted
        Meme.any_instance.stub(:save).and_return(false)
        post :create, :meme => {}
        assigns(:meme).should be_a_new(Meme)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Meme.any_instance.stub(:save).and_return(false)
        post :create, :meme => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested meme" do
        meme = Meme.create! valid_attributes
        # Assuming there are no other memes in the database, this
        # specifies that the Meme created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Meme.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => meme.id, :meme => {'these' => 'params'}
      end

      it "assigns the requested meme as @meme" do
        meme = Meme.create! valid_attributes
        put :update, :id => meme.id, :meme => valid_attributes
        assigns(:meme).should eq(meme)
      end

      it "redirects to the meme" do
        meme = Meme.create! valid_attributes
        put :update, :id => meme.id, :meme => valid_attributes
        response.should redirect_to(meme)
      end
    end

    describe "with invalid params" do
      it "assigns the meme as @meme" do
        meme = Meme.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Meme.any_instance.stub(:save).and_return(false)
        put :update, :id => meme.id.to_s, :meme => {}
        assigns(:meme).should eq(meme)
      end

      it "re-renders the 'edit' template" do
        meme = Meme.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Meme.any_instance.stub(:save).and_return(false)
        put :update, :id => meme.id.to_s, :meme => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested meme" do
      meme = Meme.create! valid_attributes
      expect {
        delete :destroy, :id => meme.id.to_s
      }.to change(Meme, :count).by(-1)
    end

    it "redirects to the memes list" do
      meme = Meme.create! valid_attributes
      delete :destroy, :id => meme.id.to_s
      response.should redirect_to(memes_url)
    end
  end

end
