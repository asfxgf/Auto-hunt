class CandidatesController < ApplicationController
  include Pundit
  acts_as_token_authentication_handler_for User, except: [ :index, :show ]
  before_action :set_candidate, only: [:show, :update, :destroy]

  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  def index
    @candidates = policy_scope(Candidate)
  end

  def show
    if current_user.id != @candidate.user_id then
      redirect_to('')
    end
  end

  def update
    if @candidate.update(candidate_params)
      render :show
    else
      render_errors
    end
  end

  def create
    @candidate = Candidate.new(candidate_params)
    @candidate.user = current_user

    authorize @candidate

    if @candidate.save
      render :show, status: :created
    else
      render_errors
    end
  end

  def destroy
    @candidate.destroy

    head :no_content
  end

  private

  def set_candidate
    @candidate = Candidate.find(params[:id])
    authorize @candidate
  end

  def candidate_params
    params.require(:candidate).permit(:name, :address)
  end

  def render_errors
    render html: { errors: @candidate.errors.full_messages },
           status: :unprocessable_entity
  end
end