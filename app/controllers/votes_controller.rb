class VotesController < ApplicationController
  # GET /votes
  # GET /votes.json
  def index
    @usernames = Array.new

    if (params[:postid] != nil)
      @users = Vote.find_all_by_post_id(params[:postid])
      @users.each do |user|
        @usernames.push(User.find_by_id(user.user_id).username)
      end
    end

    if (params[:commentid] != nil)
      @users = Vote.find_all_by_comment_id(params[:commentid])
      @users.each do |user|
        @usernames.push(User.find_by_id(user.user_id).username)
      end
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @votes }
    end
  end

  # GET /votes/1
  # GET /votes/1.json
  def show
    @vote = Vote.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @vote }
    end
  end

  # GET /votes/new
  # GET /votes/new.json
  def new
    @vote = Vote.new

    #respond_to do |format|
     # format.html # new.html.erb
      #format.json { render json: @vote }
    #end
  end

  # GET /votes/1/edit
  def edit
    @vote = Vote.find(params[:id])
  end

  # POST /votes
  # POST /votes.json
  def create
    @vote = Vote.new(params[:vote])

    respond_to do |format|
      if @vote.save
        format.html { redirect_to paths_url, notice: 'Vote was successfully created.' }
        format.json { render json: @vote, status: :created, location: @vote }
      else
        format.html { render action: "new" }
        format.json { render json: @vote.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /votes/1
  # PUT /votes/1.json
  def update
    @vote = Vote.find(params[:id])

    respond_to do |format|
      if @vote.update_attributes(params[:vote])
        format.html { redirect_to @vote, notice: 'Vote was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @vote.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /votes/1
  # DELETE /votes/1.json
  def destroy
    @vote = Vote.find(params[:id])
    @vote.destroy

    respond_to do |format|
      format.html { redirect_to votes_url }
      format.json { head :no_content }
    end
  end

  def update_votes
    authorize
    @vote = Vote.new
    @vote.user_id = session[:user_id]
    @vote.post_id =  params[:postid]
    @vote.comment_id =  params[:commentid]

    if (@vote.comment_id != nil)
      @vote.post_id = nil
    end

    if @vote.save
      Post.find_by_id(params[:postid]).touch
      redirect_to :back
    end
  end
end
