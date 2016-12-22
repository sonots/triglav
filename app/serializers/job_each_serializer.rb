class JobEachSerializer < ActiveModel::Serializer
  attributes :id, :uri, :created_at, :updated_at

  include Swagger::Blocks

  swagger_schema :JobEachResponse do
    property :id do
      key :type, :integer
      key :format, :int64
    end
    property :uri do
      key :type, :string
    end
    property :created_at do
      key :type, :integer
    end
    property :updated_at do
      key :type, :integer
    end
  end
end
