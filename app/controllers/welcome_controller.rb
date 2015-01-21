class WelcomeController < ApplicationController
  def welcome
    add_breadcrumb "Home", :root_path, :options => { :title => "Home" }
  end
end
