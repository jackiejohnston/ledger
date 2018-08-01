class TransactionsController < ApplicationController

  before_action :http_basic_authenticate

  def index
    @transactions = Transaction.all
    @payees = Transaction.distinct.pluck(:payee).sort
    @categories = Transaction.distinct.pluck(:category).sort
  end

  def create
    @transaction = Transaction.new(transaction_params)

    respond_to do |format|
      if @transaction.save
        format.html { redirect_to :root, notice: 'Transaction was successfully added to ledger.' }
        format.json { render :index, status: :created, location: @transaction }
      else
        format.html { render :index }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def transaction_params
      params.permit(:posted_on, :payee, :description, :category, :amount)
    end

    def http_basic_authenticate
      if Rails.env.production?
        authenticate_or_request_with_http_basic do |name, password|
          name == ENV["AUTH_NAME"] && password == ENV["AUTH_PASSWORD"]
        end
      end
    end

end