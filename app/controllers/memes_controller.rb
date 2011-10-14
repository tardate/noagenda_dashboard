class MemesController < ApplicationController
  # GET /memes
  # GET /memes.xml
  def index
    @memes = Meme.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @memes }
    end
  end

  # GET /memes/1
  # GET /memes/1.xml
  def show
    @meme = Meme.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @meme }
    end
  end

  # GET /memes/new
  # GET /memes/new.xml
  def new
    @meme = Meme.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @meme }
    end
  end

  # GET /memes/1/edit
  def edit
    @meme = Meme.find(params[:id])
  end

  # POST /memes
  # POST /memes.xml
  def create
    @meme = Meme.new(params[:meme])

    respond_to do |format|
      if @meme.save
        format.html { redirect_to(@meme, :notice => 'Meme was successfully created.') }
        format.xml  { render :xml => @meme, :status => :created, :location => @meme }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @meme.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /memes/1
  # PUT /memes/1.xml
  def update
    @meme = Meme.find(params[:id])

    respond_to do |format|
      if @meme.update_attributes(params[:meme])
        format.html { redirect_to(@meme, :notice => 'Meme was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @meme.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /memes/1
  # DELETE /memes/1.xml
  def destroy
    @meme = Meme.find(params[:id])
    @meme.destroy

    respond_to do |format|
      format.html { redirect_to(memes_url) }
      format.xml  { head :ok }
    end
  end
end
