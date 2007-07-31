class CreditCardsController < ApplicationController
  # GET /credit_cards
  # GET /credit_cards.xml
  def index
    @credit_cards = CreditCard.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @credit_cards }
    end
  end

  # GET /credit_cards/1
  # GET /credit_cards/1.xml
  def show
    @credit_card = CreditCard.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @credit_card }
    end
  end

  # GET /credit_cards/new
  # GET /credit_cards/new.xml
  def new
    @credit_card = CreditCard.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @credit_card }
    end
  end

  # GET /credit_cards/1/edit
  def edit
    @credit_card = CreditCard.find(params[:id])
  end

  # POST /credit_cards
  # POST /credit_cards.xml
  def create
    @credit_card = CreditCard.new(params[:credit_card])

    respond_to do |format|
      if @credit_card.save
        flash[:notice] = 'CreditCard was successfully created.'
        format.html { redirect_to(@credit_card) }
        format.xml  { render :xml => @credit_card, :status => :created, :location => @credit_card }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @credit_card.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /credit_cards/1
  # PUT /credit_cards/1.xml
  def update
    @credit_card = CreditCard.find(params[:id])

    respond_to do |format|
      if @credit_card.update_attributes(params[:credit_card])
        flash[:notice] = 'CreditCard was successfully updated.'
        format.html { redirect_to(@credit_card) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @credit_card.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /credit_cards/1
  # DELETE /credit_cards/1.xml
  def destroy
    @credit_card = CreditCard.find(params[:id])
    @credit_card.destroy

    respond_to do |format|
      format.html { redirect_to(credit_cards_url) }
      format.xml  { head :ok }
    end
  end
end
