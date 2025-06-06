abstract class BaseSerializer
  include Lucky::Serializable

  def self.for_collection(collection : Enumerable, *args, **named_args) : Array(self)
    collection.map do |object|
      new(object, *args, **named_args)
    end
  end

  def self.for_collection(collection : Enumerable, pages : Lucky::Paginator, *args, **named_args)
    {
      "items" => collection.map do |object|
        new(object, *args, **named_args)
      end,
      "pagination" => PaginationSerializer.new(pages),
    }
  end
end
