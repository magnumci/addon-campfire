require "spec_helper"

describe Magnum::Addons::Campfire do
  describe "#initialize" do
    it "requires api token" do
      expect { described_class.new }.
        to raise_error Magnum::Addons::Campfire::Error, "API token required"
    end

    it "requires subdomain" do
      expect { described_class.new(api_token: "token") }.
        to raise_error Magnum::Addons::Campfire::Error, "Subdomain required"
    end

    it "requires room id" do
      expect { described_class.new(api_token: "token", subdomain: "foo") }.
        to raise_error Magnum::Addons::Campfire::Error, "Room required"
    end

    context "with valid arguments" do
      let(:options) do
        { api_token: "token", subdomain: "foo", room: "12345" }
      end

      it "does not raise error" do
        expect { described_class.new(options) }.not_to raise_error
      end
    end
  end

  describe "#run" do
    let(:addon)   { described_class.new(api_token: "token", subdomain: "foo", room: 12345) }
    let(:payload) { JSON.load(fixture("build.json")) }

    it "requires hash object" do
      expect { addon.run(nil) }.
        to raise_error ArgumentError, "Hash required"
    end

    context "with valid data" do
      before do
        response = double
        response.stub(:success?) { true}
        Faraday::Connection.any_instance.stub(:post) { response }
      end

      it "sends message payload" do
        expect(addon).to receive(:make_api_request).exactly(4).times
        addon.run(payload)
      end
    end

    context "when api token is invalid" do
      before do
        stub_request(:post, "https://token:x@foo.campfirenow.com/room/12345/speak.json").
         with(:body => "{\"message\":{\"body\":\"[PASS] slack-notify #3 (master - 6f102f22) by Dan Sosedoff\"}}",
              :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.8.8'}).
         to_return(:status => 401, :body => "", :headers => {})
      end

      it "raises error" do
        expect { addon.run(payload) }.
          to raise_error Magnum::Addons::Campfire::Error, "Invalid credentials"
      end
    end

    context "when room id is invalid" do
      before do
        stub_request(:post, "https://token:x@foo.campfirenow.com/room/12345/speak.json").
         with(:body => "{\"message\":{\"body\":\"[PASS] slack-notify #3 (master - 6f102f22) by Dan Sosedoff\"}}",
              :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.8.8'}).
         to_return(:status => 404, :body => "", :headers => {})
      end

      it "raises error" do
        expect { addon.run(payload) }.
          to raise_error Magnum::Addons::Campfire::Error, "Invalid room"
      end
    end

    context "when request fails" do
      before do
        stub_request(:post, "https://token:x@foo.campfirenow.com/room/12345/speak.json").
         with(:body => "{\"message\":{\"body\":\"[PASS] slack-notify #3 (master - 6f102f22) by Dan Sosedoff\"}}",
              :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.8.8'}).
         to_return(:status => 500, :body => "", :headers => {})
      end

      it "raises error" do
        expect { addon.run(payload) }.
          to raise_error Magnum::Addons::Campfire::Error
      end
    end
  end
end