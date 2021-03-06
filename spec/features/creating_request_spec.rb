feature 'FEATURE: Creating a request' do

  let(:name) { "Pedro's House" }
  let(:description) { "Very nice" }
  let(:price) { 200 }
  let(:from) { "20/02/2017" }
  let(:to) { "20/05/2017" }
  let(:image_url) { "http://cdn.freshome.com/wp-content/uploads/2012/10/bes-small-apartments-designs-ideas-image-17.jpg" }
  let(:test_user) { "Rick" }
  let(:username) { "RICK" }
  let(:email) { "rick@rick.com" }
  let(:password_digest) { "rick" }
  let(:password_confirmation) { "rick" }

  before(:each) do
    allow(Messenger).to receive(:call)
  end

  scenario 'when not logged in' do
    sign_up
    create_new_space(name: name, description: description, price: price, from: from, to: to, image_url: image_url)
    click_button("Sign Out")
    visit '/'
    click_link("Pedro's House")
    expect(page).not_to have_button("request_to_book")
  end

  scenario 'logged in user is able to book', :js => true do
    sign_up
    create_new_space(name: name, description: description, price: price, from: from, to: to, image_url: image_url)
    space_id = Space.first.id
    visit "/spaces/#{space_id}"
    page.execute_script("$('#hidden_date').val('21/02/2017')")
    expect{click_button('request_to_book')}.to change{Request.count}.by(1)
    expect(page).to have_content("Your request has been sent!")
  end

  scenario 'cant select dates that have already been approved', :js => true do
    current_user = User.create(name: test_user,
                        username: username,
                        email: email,
                        password_digest: password_digest,
                        password_confirmation: password_confirmation)
    space = current_user.spaces.create(name: name,
                                         description: description,
                                         price: price,
                                         from: from,
                                         to:  to,
                                         image_url: image_url
                                        )
    space_id = Space.first.id
    existing_request = Request.create(date: "25/03/2017",
                                      status: "confirmed",
                                      user_id: current_user.id,
                                      space_id: space_id )
    sign_up
    visit "/spaces/#{space_id}"
    page.execute_script("$('#hidden_date').val('25/03/2017')")
    expect{click_button('request_to_book')}.not_to change{Request.count}
  end

end
