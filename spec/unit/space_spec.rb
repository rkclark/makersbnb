describe Space do

  let(:name) { "Pedro's House" }
  let(:description) { "Very nice" }
  let(:price) { 200 }
  let(:from) { "20/01/2017" }
  let(:to) { "20/02/2017" }

  subject(:space) { described_class.create(name: name, description: description, price: price, from: from, to: to) }

  let(:request_one) { double("Request") }
  let(:request_two) { double("Request") }
  let(:requests) { [request_one, request_two] }

  xdescribe "#booked_dates" do
    it "returns an array of booked dates" do
      allow(space).to receive(:requests) { requests }
      allow(request_one).to receive(:status) { "Approved" }
      allow(request_one).to receive(:date) { "20/02/2017" }
      allow(request_two).to receive(:status) { "Approved" }
      allow(request_two).to receive(:date) { "21/02/2017" }
      expect(space.booked_dates).to eq(["20/02/2017","21/02/2017"])
    end
  end

end
