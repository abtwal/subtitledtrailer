class MediaitemsController < ApplicationController
  def index
    @mediaitems = Mediaitem.limit(10)
    render component: 'Mediaitems', props: { mediaitems: @mediaitems }
  end
end
