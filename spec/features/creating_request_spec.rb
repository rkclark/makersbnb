feature 'FEATURE: Creating a request' do

  let(:name) { "Pedro's House" }
  let(:description) { "Very nice" }
  let(:price) { 200 }
  let(:from) { "20/03/2017" }
  let(:to) { "20/05/2017" }
  let(:test_user) { "Rick" }
  let(:username) { "RICK" }
  let(:email) { "rick@rick.com" }
  let(:password_digest) { "rick" }
  let(:password_confirmation) { "rick" }

  xscenario 'logged in user is able to create a request' do
    sign_up
    create_new_space(name: name, description: description, price: price, from: from, to: to)
    visit '/' #update later
    expect(page).to have_button("Request to Book")
  end

  xscenario 'when not logged in' do
    visit '/' #update later
    expect(page).not_to have_button("request_to_book")
  end

  scenario 'logged in user is able to book' do
    sign_up
    create_new_space(name: name, description: description, price: price, from: from, to: to)
    space_id = Space.first.id
    visit "/spaces/#{space_id}"
    fill_in(:date, with: "31/01/2017")
    expect{click_button('request_to_book')}.to change{Request.count}.by(1)
  end

  xscenario 'cant select dates that have already been approved' do
    current_user = User.create(name: test_user,
                        username: username,
                        email: email,
                        password_digest: password_digest,
                        password_confirmation: password_confirmation)
    space = current_user.spaces.create(name: name,
                                         description: description,
                                         price: price,
                                         from: from,
                                         to:  to
                                        )
    space_id = Space.first.id
    existing_request = Request.create(date: "25/03/2017",
                                      status: "Approved",
                                      user_id: user_id,
                                      space_id: space_id )
    visit "/spaces/#{space_id}"
    fill_in(:date, with: "25/03/2017")
    expect{click_button('request_to_book')}.not_to change{Request.count}
  end

end
