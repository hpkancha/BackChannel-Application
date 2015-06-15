class PostsController < ApplicationController

  # GET /posts
  # GET /posts.json
  def index
    @isOwnPost = Array.new
    @userVoted = Array.new
    @posts = Post.all
    @posts.each do |post|
      @isOwnPost[post.id] = (session[:user_id] != nil) &&
          (post.user_id == session[:user_id] || User.find_by_id(session[:user_id]).isadmin)
      @userVoted[post.id] = (Vote.find_by_post_id_and_user_id(post.id, session[:user_id]) != nil ||
          session[:user_id] == nil)
    end

      respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/1/edit
  def edit
    authorize
    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.json
  def create
    authorize
    @post = Post.new(params[:post])
    @post.user_id = session[:user_id]

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render json: @post, status: :created, location: @post }
      else
        format.html { render action: "new" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end

  def search
    @user_opt = params[:user_opt]
    @key = params[:q]
    @isOwnPost = Array.new
    @userVoted = Array.new
    @posts = Array.new

    if @user_opt.to_i == 1
      @posts = Post.where("title like ? or message like ?", "%" + params[:q] +"%","%"+ params[:q] + "%")
    elsif @user_opt.to_i == 2
      @users = User.where("username like ?", "%" + params[:q] +"%")
      @users.each do |user|
        @posts = @posts + Post.find_all_by_user_id(user.id)
      end
    else
      @categories = Category.where("name like ?", "%" + params[:q] +"%")
      @categories.each do |category|
        @posts = @posts + Post.find_all_by_category_id(category.id)
      end
    end

    @msg = "Search Results."

    if @posts.empty?
      @msg = "No search results found. Try new search"
    end

    @posts.each do |post|
      @isOwnPost[post.id] = (session[:user_id] != nil) &&
          (post.user_id == session[:user_id] || User.find_by_id(session[:user_id]).isadmin)
      @userVoted[post.id] = (Vote.find_by_post_id_and_user_id(post.id,
                                                              session[:user_id]) != nil || session[:user_id] == nil)
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @posts }
    end

  end

  def activity
    @posts = Post.all
    @votes = Hash.new

    @posts.each do |post|
      @votes[post.id] = Vote.find_all_by_post_id(post.id).count
    end

    @votes.sort_by {|post_id, votes| votes}.reverse

  end

end
