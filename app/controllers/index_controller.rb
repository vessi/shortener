# frozen_string_literal: true

class IndexController < ApplicationController
  def index; end

  def short_url
    shorten = UrlShortener.store(url: params[:url], base_host: root_url)
    render json: { short_url: shorten, url: params[:url] }
  end

  def unshort_url
    unshorten = UrlShortener.fetch(shorten_url: params[:short_url])
    redirect_to unshorten, status: :moved_permanently
  rescue UrlShortener::NotFoundError
    render :index
  end
end
