class Herbicide < ApplicationRecord
    def as_json(options = {})
    super(options).merge(prix: prix)
  end
end
