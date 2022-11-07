# frozen_string_literal: true

Rails.application.routes.draw do
  resources :satellites, only: %i[index]
end
