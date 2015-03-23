source 'https://rubygems.org'
ruby '2.2.1'

# Standard Rails gems
gem 'rails', '4.2.0'
gem 'sass-rails', '5.0.1'
gem 'uglifier', '2.7.1'
gem 'coffee-rails', '4.1.0'
gem 'jquery-rails', '4.0.3'
gem 'turbolinks', '2.5.3'
gem 'jbuilder', '2.2.11'
gem 'bcrypt', '3.1.10'

# Necessary for Windows OS (won't install on *nix systems)
gem 'tzinfo-data', platforms: [:mingw, :mswin]

# Kaminari: https://github.com/amatsuda/kaminari
gem 'kaminari', '0.16.3'

# Friendly_id: https://github.com/norman/friendly_id
gem 'friendly_id', '5.1.0'

# Font-awesome: https://github.com/FortAwesome/font-awesome-sass
gem 'font-awesome-sass', '4.3.1'

# Bootstrap 3: https://github.com/twbs/bootstrap-sass
gem 'bootstrap-sass', '3.3.3'

# Phone number validation and formatting
gem 'phony_rails'

group :development, :test do
  gem 'byebug', '3.5.1'
  gem 'web-console', '2.1.1'

  # Figaro: https://github.com/laserlemon/figaro
  gem 'figaro', '1.1.0'

  # Spring: https://github.com/rails/spring
  gem 'spring', '1.3.3'
end


# SQLite 3
group :development, :test do
  gem 'sqlite3', '1.3.10'
end

# Devise: https://github.com/plataformatec/devise
gem 'devise', '3.4.1'

# Rails 12factor for Heroku: https://github.com/heroku/rails_12factor
group :production do
  gem 'rails_12factor'
end

# PostgreSQL gem for Heroku
group :production do
  gem 'pg'
end

# Unicorn: http://unicorn.bogomips.org
group :production do
  gem 'unicorn'
end
