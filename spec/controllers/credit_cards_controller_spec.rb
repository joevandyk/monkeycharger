require File.dirname(__FILE__) + '/../spec_helper'

describe CreditCardsController, "#route_for" do

  it "should map { :controller => 'credit_cards', :action => 'index' } to /credit_cards" do
    route_for(:controller => "credit_cards", :action => "index").should == "/credit_cards"
  end
  
  it "should map { :controller => 'credit_cards', :action => 'new' } to /credit_cards/new" do
    route_for(:controller => "credit_cards", :action => "new").should == "/credit_cards/new"
  end
  
  it "should map { :controller => 'credit_cards', :action => 'show', :id => 1 } to /credit_cards/1" do
    route_for(:controller => "credit_cards", :action => "show", :id => 1).should == "/credit_cards/1"
  end
  
  it "should map { :controller => 'credit_cards', :action => 'edit', :id => 1 } to /credit_cards/1/edit" do
    route_for(:controller => "credit_cards", :action => "edit", :id => 1).should == "/credit_cards/1/edit"
  end
  
  it "should map { :controller => 'credit_cards', :action => 'update', :id => 1} to /credit_cards/1" do
    route_for(:controller => "credit_cards", :action => "update", :id => 1).should == "/credit_cards/1"
  end
  
  it "should map { :controller => 'credit_cards', :action => 'destroy', :id => 1} to /credit_cards/1" do
    route_for(:controller => "credit_cards", :action => "destroy", :id => 1).should == "/credit_cards/1"
  end
  
end


describe CreditCardsController, "handling GET /credit_cards/1" do
  before do
    @credit_card = mock_model(CreditCard)
    CreditCard.stub!(:find).and_return(@credit_card)
  end
  
  def do_get
    get :show, :id => "1"
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should render show template" do
    do_get
    response.should render_template('show')
  end
  
  it "should find the credit_card requested" do
    CreditCard.should_receive(:find).with("1").and_return(@credit_card)
    do_get
  end
  
  it "should assign the found credit_card for the view" do
    do_get
    assigns[:credit_card].should equal(@credit_card)
  end
end

describe CreditCardsController, "handling GET /credit_cards/1.xml" do

  before do
    @credit_card = mock_model(CreditCard, :to_xml => "XML")
    CreditCard.stub!(:find).and_return(@credit_card)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :show, :id => "1"
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should find the credit_card requested" do
    CreditCard.should_receive(:find).with("1").and_return(@credit_card)
    do_get
  end
  
  it "should render the found credit_card as xml" do
    @credit_card.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

describe CreditCardsController, "handling GET /credit_cards/new" do

  before do
    @credit_card = mock_model(CreditCard)
    CreditCard.stub!(:new).and_return(@credit_card)
  end
  
  def do_get
    get :new
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should render new template" do
    do_get
    response.should render_template('new')
  end
  
  it "should create an new credit_card" do
    CreditCard.should_receive(:new).and_return(@credit_card)
    do_get
  end
  
  it "should not save the new credit_card" do
    @credit_card.should_not_receive(:save)
    do_get
  end
  
  it "should assign the new credit_card for the view" do
    do_get
    assigns[:credit_card].should equal(@credit_card)
  end
end

describe CreditCardsController, "handling GET /credit_cards/1/edit" do

  before do
    @credit_card = mock_model(CreditCard)
    CreditCard.stub!(:find).and_return(@credit_card)
  end
  
  def do_get
    get :edit, :id => "1"
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should render edit template" do
    do_get
    response.should render_template('edit')
  end
  
  it "should find the credit_card requested" do
    CreditCard.should_receive(:find).and_return(@credit_card)
    do_get
  end
  
  it "should assign the found CreditCard for the view" do
    do_get
    assigns[:credit_card].should equal(@credit_card)
  end
end

describe CreditCardsController, "handling POST /credit_cards" do

  before do
    @credit_card = mock_model(CreditCard, :to_param => "1", :save => true)
    CreditCard.stub!(:new).and_return(@credit_card)
    @params = {}
  end
  
  def do_post
    post :create, :credit_card => @params
  end
  
  it "should create a new credit_card" do
    CreditCard.should_receive(:new).with(@params).and_return(@credit_card)
    do_post
  end

  it "should redirect to the new credit_card" do
    do_post
    response.should redirect_to(credit_card_url("1"))
  end
end

describe CreditCardsController, "handling PUT /credit_cards/1" do

  before do
    @credit_card = mock_model(CreditCard, :to_param => "1", :update_attributes => true)
    CreditCard.stub!(:find).and_return(@credit_card)
  end
  
  def do_update
    put :update, :id => "1"
  end
  
  it "should find the credit_card requested" do
    CreditCard.should_receive(:find).with("1").and_return(@credit_card)
    do_update
  end

  it "should update the found credit_card" do
    @credit_card.should_receive(:update_attributes)
    do_update
    assigns(:credit_card).should equal(@credit_card)
  end

  it "should assign the found credit_card for the view" do
    do_update
    assigns(:credit_card).should equal(@credit_card)
  end

  it "should redirect to the credit_card" do
    do_update
    response.should redirect_to(credit_card_url("1"))
  end
end

describe CreditCardsController, "handling DELETE /credit_cards/1" do

  before do
    @credit_card = mock_model(CreditCard, :destroy => true)
    CreditCard.stub!(:find).and_return(@credit_card)
  end
  
  def do_delete
    delete :destroy, :id => "1"
  end

  it "should find the credit_card requested" do
    CreditCard.should_receive(:find).with("1").and_return(@credit_card)
    do_delete
  end
  
  it "should call destroy on the found credit_card" do
    @credit_card.should_receive(:destroy)
    do_delete
  end
  
  it "should redirect to the credit_cards list" do
    do_delete
    response.should redirect_to(credit_cards_url)
  end
end
