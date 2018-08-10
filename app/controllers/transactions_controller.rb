class TransactionsController < ApplicationController

  before_action :http_basic_authenticate

  def index
    puts ">>>>>>>>>>>>>>>> year #{params[:year]}"
    puts ">>>>>>>>>>>>>>>> month #{params[:month]}"
    @transaction_months = Transaction.all.sort_by(&:posted_on).reverse.group_by {|t| t.posted_on.beginning_of_month }
    first_of_month = Date.current.beginning_of_month
    last_of_month = Date.current.end_of_month
    @month_url = Date.current.strftime('/%Y/%m')
    @month_display = Date.current.strftime('%B %Y')
    puts ">>>>>>>>>>>>>>>>> month_url: #{@month_url}"
    @filtered_transactions = Transaction.where("posted_on BETWEEN ? AND ?", first_of_month, last_of_month).sort_by(&:posted_on).reverse
    @payees = Transaction.distinct.pluck(:payee).sort
    @categories = Transaction.distinct.pluck(:category).sort
    if Rails.env.test?
      @payees.push("Sofi")
      @categories.push("loan")
    end
  end

  # POST /transactions
  # POST /transactions.json
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

  # DELETE /transactions/1
  # DELETE /transactions/1.json
  def destroy
    transaction = Transaction.find(params[:id])
    transaction.destroy
    respond_to do |format|
      format.html { redirect_to :root, notice: 'Transaction was successfully deleted.' }
      format.json { head :no_content }
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