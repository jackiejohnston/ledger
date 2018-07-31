class TransactionsController < ApplicationController
  def index
    @transactions = Transaction.all
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
      params.permit(:posted_on, :payee, :description, :category, :amount, :deposit)
    end
end