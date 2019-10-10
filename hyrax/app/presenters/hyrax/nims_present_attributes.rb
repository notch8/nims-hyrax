module Hyrax
  module NimsPresentAttributes
    def first_title
      CGI.unescape(title.first)
    end
  end
end

Hyrax::FileSetPresenter.prepend(Hyrax::NimsPresentAttributes)
