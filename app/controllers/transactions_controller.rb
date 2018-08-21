class TransactionsController < ApplicationController

  before_action :http_basic_authenticate
  before_action :set_s3_direct_post, only: [:index, :create, :update]

  def index
    @transaction_months = Transaction.all.sort_by(&:posted_on).reverse.group_by {|t| t.posted_on.beginning_of_month }
    @first_of_month = params[:year].present? && params[:month].present? ? Date.parse("#{params[:year]}-#{params[:month]}-01") : Date.current.beginning_of_month
    @last_of_month = @first_of_month.end_of_month
    @month_url = @first_of_month.strftime("/%Y/%m")
    @month_display = @first_of_month.strftime("%B %Y")
    @filtered_transactions = Transaction.where("posted_on BETWEEN ? AND ?", @first_of_month, @last_of_month).sort_by(&:posted_on).reverse
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

  # PATCH/PUT /transactions/1
  # PATCH/PUT /transactions/1.json
  def update
    @transaction = Transaction.find(params[:id])
    respond_to do |format|
      if @transaction.update_attributes(transaction_update_params)
        format.html { redirect_back fallback_location: root_path, notice: 'Transaction was successfully updated.' }
        format.json { respond_with_bip(@transaction) }
      else
        format.html { render :edit }
        format.json { respond_with_bip(@transaction) }
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
      params.permit(:posted_on, :payee, :description, :category, :amount, :receipt)
    end

    def transaction_update_params
      if !params[:transaction][:posted_on].nil?
        params[:transaction][:posted_on] = Date.strptime(params[:transaction][:posted_on], "%m/%d/%Y").to_s
      end
      params.require(:transaction).permit(:posted_on, :payee, :description, :category, :amount, :receipt)
    end

    def http_basic_authenticate
      if Rails.env.production?
        authenticate_or_request_with_http_basic do |name, password|
          name == ENV["AUTH_NAME"] && password == ENV["AUTH_PASSWORD"]
        end
      end
    end

    def set_s3_direct_post
      @s3_direct_post = S3_BUCKET.presigned_post(key: "#{SecureRandom.uuid}/${filename}", success_action_status: '201', acl: 'public-read')
    end

end