# coding: utf-8
require 'rails_helper'

RSpec.describe 'Message resources', :type => :request do

  let(:params) do
    {}
  end

  let(:env) do
    {
      'CONTENT_TYPE' => 'application/json',
      'HOST' => 'triglav.analytics.mbga.jp',
      'HTTP_ACCEPT' => 'application/json',
      'HTTP_AUTHORIZATION' => access_token,
    }
  end

  let(:access_token) do
    ApiKey.create(user_id: user.id).access_token
  end

  let(:user) do
    FactoryGirl.create(:user, :triglav_admin)
  end

  let(:message) do
    FactoryGirl.create(:message)
  end

  describe "List messages", :autodoc do

    let(:description) do
      "List messages whose message id is greater than or equal to offset with HTTP GET method<br/>" \
      "<br/>" \
      "`offset` is required.<br/>" \
      "`resource_uris` are optional, but one resource_uri should be set usually.<br/>" \
      "`limit` is optional, and default is 100.<br/>" \
      "`resource_unit` is optional, but required if `resource_time` is given.<br/>" \
      "`resource_time` is optional.<br/>" \
      "Returned `resource_time` is in unix timestamp<br/>" \
      "<br/>" \
      "You can use either of GET /messages or POST /fetch_messages, but note that GET has limitation for query parameters length<br/>"
    end

    let(:params) do
      {
        offset: message.id,
        limit: 100,
        resource_uris: [message.resource_uri],
        resource_unit: message.resource_unit,
        resource_time: message.resource_time,
      }
    end

    it "GET /api/v1/messages" do

      get "/api/v1/messages", params: params, env: env

      expect(response.status).to eq 200

    end
  end

  describe "Fetch messages", :autodoc do

    let(:description) do
      "Fetch messages whose message id is greater than or equal to offset with HTTP POST method<br/>" \
      "<br/>" \
      "`offset` is required.<br/>" \
      "`resource_uris` are optional, but one resource_uri should be set usually.<br/>" \
      "`limit` is optional, and default is 100<br/>" \
      "`resource_unit` is optional, but required if `resource_time` is given.<br/>" \
      "`resource_time` is optional.<br/>" \
      "Returned `resource_time` is in unix timestamp<br/>" \
      "<br/>" \
      "You can use either of GET /messages or POST /fetch_messages, but note that GET has limitation for query parameters length<br/>"
    end

    let(:params) do
      {
        offset: message.id,
        limit: 100,
        resource_uris: [message.resource_uri],
        resource_unit: message.resource_unit,
        resource_time: message.resource_time,
      }
    end

    it "POST /api/v1/fetch_messages" do

      post "/api/v1/fetch_messages", params: params.to_json, env: env

      expect(response.status).to eq 200

    end
  end

  describe "Send messages", :autodoc do

    let(:description) do
      "Send messages<br/>" \
      "<br/>" \
      "`resource_time` is in unix timestamp<br/>"
    end

    let(:message) do
      FactoryGirl.build(:message)
    end

    let(:params) do
      [message.attributes.slice(*MessageSerializer.request_permit_params.map(&:to_s))]
    end

    it "POST /api/v1/messages" do

      post "/api/v1/messages", params: params.to_json, env: env

      expect(response.status).to eq 200

    end
  end

  describe "Get last message id", :autodoc do

    let(:description) do
      "Get last message id which would be used as a first offset to fetch messages<br/>"
    end

    it "GET /api/v1/messages/last_id" do
      FactoryGirl.create(:message)

      get "/api/v1/messages/last_id", params: nil, env: env

      expect(response.status).to eq 200

    end
  end

end
