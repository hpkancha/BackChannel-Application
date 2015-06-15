class CommentsController < ApplicationController
  # GET /comments
  # GET /comments.json
  def index
    @isOwnComment = Array.new
    @userVotedForComment = Array.new

    @post = Post.find_by_id(params[:postid])
    @comments = Comment.find_all_by_post_id(@post.id)

    @isOwnPost = (session[:user_id] != nil) &&
        (@post.user_id == session[:user_id] || User.find_by_id(session[:user_id]).isadmin)
    @userVotedForPost = (Vote.find_by_post_id_and_user_id(@post.id, session[:user_id]) != nil ||
        session[:user_id] == nil)

    @comments.each do |comment|
      @isOwnComment[comment.id] = (comment.user_id == session[:user_id] || User.find_by_id(session[:user_id]).isadmin)
      @userVotedForComment[comment.id] = (Vote.find_by_comment_id_and_user_id(comment.id, session[:user_id]) != nil ||
          session[:user_id] == nil)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @comments }
    end
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
    @comment = Comment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @comment }
    end
  end

  # GET /comments/new
  # GET /comments/new.json
  def new
    @comment = Comment.new
    session[:postid] = params[:postid]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @comment }
    end
  end

  # GET /comments/1/edit
  def edit
    @comment = Comment.find(params[:id])
  end

  # POST /comments
  # POST /comments.json
  def create
    authorize
    @comment = Comment.new(params[:comment])
    @comment.user_id = session[:user_id]
    @comment.post_id = session[:postid]

    respond_to do |format|
      if @comment.save
        Post.find_by_id(session[:postid]).touch
        session[:postid] = nil
        format.html { redirect_to @comment, notice: 'Comment was successfully created.' }
        format.json { render json: @comment, status: :created, location: @comment }
      else
        format.html { render action: "new" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.json
  def update
    authorize
    @comment = Comment.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to comments_url }
      format.json { head :no_content }
    end
  end
end
