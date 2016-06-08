class AnswersController < ApplicationController


  before_action :authenticate_user!, only: [:new, :edit, :update, :destroy]
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :find_question, only: [:create, :show, :edit, :new, :update, :destroy]
  before_filter :require_permission, only: [:new ,:create]

  #before_filter :require_permission, only: [:edit, :destroy]

  def index
    @answers=Answer.all
  end

  def show

  end

  # GET /posts/new
  def new
    @answer= @question.answers.new
    render json: {html: render_to_string("/answers/_form", layout: false, locals: {question_id: @question})} and return
  end

  def edit

  end


  def create
    @answer= @question.answers.new(post_params)
    @answer.user = current_user
    respond_to do |format|
      @answer.save
        format.html {redirect_to @question, notice: t(:question_comment_create)}
        format.js { render '/answers/show.js.erb'}

    end
  end

  def update

    if @answer.check_history?
      p true
      params = post_params.merge(history_id: @answer.id)
      @answer= @question.answers.new(params)
       @answer.user = current_user
      @answer.save
    else
      p false
      params = post_params.merge(history_id: @answer.history_id)
      @answer= @question.answers.new(params)
       @answer.user = current_user
      @answer.save
    end


    if @answer.save
       redirect_to  @question, notice: t(:answer_updated)

    else
      render :edit

    end

    # if @answer.update(post_params)
    #   redirect_to @question, notice: 'Answer was successfully updated.'
    #   #format.json { render :show, status: :ok, location: @article }
    # else
    #   render :edit
    #   #format.json { render json: questions_path.errors, status: :unprocessable_entity }
    # end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    p request.method
    @answer.destroy
    redirect_to @question, notice: t(:answer_destroy)

  end
  def answer_history
    @answer_history = Answer.list_comment_history(params[:history_id], params[:dont_show])
  end





  private
    # Use callbacks to share common setup or constraints between actions.
  def set_post
    @answer = Answer.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def post_params
    params.require(:answer).permit(:answer)
  end

  def find_question
    @question = Question.find(params[:question_id])
  end
  def require_permission
      unless current_user.answers.where(question_id: @question).first.blank?
        redirect_to @question, notice: 'You are not allowed to answer this question again'
    #Or do something else here

      end
  end

end


