# Base image:
FROM ruby:2.6.3

# Install dependencies
# RUN apt-get update -qq && apt-get install -y build-essential libpq-dev mysql-client apt-transport-https ca-certificates
RUN apt-get update -qq && apt-get install -y build-essential apt-transport-https ca-certificates

# Install nodejs and yarn
# RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install -y nodejs
RUN npm install --global yarn

# Set an environment variable where the Rails app is installed to inside of Docker image:
ENV RAILS_ROOT /var/www/video-demo
RUN mkdir -p $RAILS_ROOT

# Set working directory, where the commands will be ran:
WORKDIR $RAILS_ROOT

# Copy the main application.
COPY . .
COPY config/database.docker.yml config/database.yml

# Gems:
# COPY Gemfile Gemfile
# COPY Gemfile.lock Gemfile.lock
RUN gem install bundler
RUN bundle install --without development test

# Puma
# COPY config/puma.rb config/puma.rb

RUN bundle exec rake assets:precompile RAILS_ENV=production \
    SECRET_KEY_BASE=OXfsz3B1pvdX8H0zE3x1l+yGtJ2mM2eNTXzLbE9Cu9DgwpTAGlnnu+wa9Qb1ZX5/7uoBxQqUBXd9P9UZU60ci/1EVp1TdS57cuh2EtI4m7awV69YF9ZOj2+XJlADQBGW/CC6cATjE4LGKe6OrgUXTSrnlh0QNuKPYTrFuxqfQImHOMMBsr1nS1j4lqu3UtvY+95MnMvx7BYIAeDlcRLO+A6yxkdxZKiAx0/1Utm20wWX3Z46+Zi2xuxuL37T3MGjMeVPCHLDWZD0x3nLd3H2xPnadw/gr1L4jd+2FUR+tYf/vk+0oD7MPn+CJ+PAk5anmi5bIqJuhx4dRyd+45WnGj/vPfLL5XOHRF8F1bmvxB7OCFTPpKtVyoJ23R4Y0kBCjnoOxV0JoMTObN53Fgpj+vDhNxHb/8vj5P6Y--NRugcu3T2ocTAZrC--bLcxAq9XI2c9Bp+4Pvt0jQ==
    # SLEEKR_ENCRYPTOR_SALT=B2M\xE9t\xC0.G\xFC\xE7\xDD\xEF\xEFCO\v\xF8\xE1{R\x0E\x18\x98\x14{\v?\x9F\xA7\xBC\x87_ \
    # SLEEKR_ENCRYPTOR_SECRET=01eff1f3c77c513bceeb92fb09f089fc \
    # GOOGLE_CLOUD_PROJECT_ID=sleekr-hr-staging \
    # GOOGLE_CLOUD_STORAGE_BUCKET=hr-docker-test \
    # GOOGLE_CLOUD_KEYFILE_JSON='{"private_key":"-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDZ9TShn5x6dWWi\n42Z2Y3Ry1BvweF5aRrPVS898JcCNK9Vm6QHWU+NTAMfCz5JB3nAzspaQIPuSEb68\nJ/WoMfHnfbF2oqmu9m1PpguhmA8xQyJI2WQwHv2w3f8K2nn48hB3wCAG2oAIzyLP\n+geetjBG/lbv2CthQOQo/o3/+v7xEZqoFlvJ5S3WreEezWYDWyAWjEEAydZm3GA1\nhAM4EqZvp90hTkgwL7rVdiP8umyfW6OOuN5Aezy5JTDRNeUPmVehm/GHAP6CsWsv\n7NXz7elwawGNy+DSLQaRB2xHKyw3p+P6RepW22hA611Y2JBH1/fTbWujfQfzmv3B\n9RPQDoDLAgMBAAECggEABw5zCG+lHpyB9BiKa1rOuXOp4iARvCp91HICjapnrQ3v\nIsh4bPqhaXoWxK4VfTxx7mU3HHU8BSovr/7l3Se5r+QQ/XOd1zKBdbVZnpt7Bf4p\nF8ZAOssNLV2fBuLtqqtrm0o9+BdHUzqTVRFOyIPC1UJ2waQ7WKR8voxbseXrvNzk\n0A51Km+3h66kO5vFozL4L1r+JMVDmOQJ+JAgo642etr6rpKEY9goKFnNbquh1rXe\nrCnBzwkNfFMpP/QgF/6KSOJA1yjSd6xa6KxbK7TGhlBZ+W8sAcRh3NqMnMlWHTNA\n1EBHH80qwh32OFDl5/gFjps/II9aDc7yF2TzjZsaAQKBgQD/aYbW5fL9NPH9D62K\n6ROqxib+VbMprQzKePC3WN9MN7BeyA0Or4xkVZoy7yLvfDhGiL2xVOdMMdbNOyXt\neOBGxXTlYJI6vtX7Web3daEic2hGxjdrFyR96mWvZZfyafvHMmXKmn04zT1zqCYF\nHuW9E7utg30559+HrM13ZxqHYQKBgQDadZzwPp/ohtInrOKTDJXgfuEchEhkqd/4\nYqnH0dNtSXyQLdXw/H8kPw9CSipbST8G+uIAo3voKGvaXMl/8Iv2Hhk4DvWX103F\n4qjZxFbNzRluaxn4WiRNTRV+3WzpAg8EmkTZ6HcUZ5SrQ/KSBsUOFbeXzqyxwNwv\nEg2EE/XzqwKBgCZETkKGQ0iylQsAPVURpLOyaocymdxFpCP1yML/mr0VnuQkfuhT\nXuptdOPqtkZBS0EuHZWjDeB5myA2m3Ef6iJQVTpEpMQOcYruJk+vHQxHVDk+W3E9\nD2eaJdAInaJhRKrMnzmiud43ydw5NjEQNwWEHltZ1vpFBlWSi1o3ZV8hAoGACLQU\n25FzJ31vk/sUT815jyce6tbuV2xZKvkrUHWwmbMKzme1FVPJ8PS+M+LmixqA81M9\ne88Hmbk6ismVkY5Q1S5fzNbzu+ftBkxAc+SZnLtmHvsPXtCgj5/ZkmNZ+nKFjKZk\nxdW4IMz7pFMhr+WrJiOBW//062QGoa1zcmalLt8CgYB0aiUkG5dduszZ5/pd3qOe\nGSiVWNqHI5cnlUu18ezU/0koLPTbO5wId93QOTzrBNBeMtX+edVJdVAVpm0JL6BO\nYqYA5SuqcY0yf2EuctnD/TFqJqbTz/g2tNsuIKlL4K1cKonloTr5jklH8qnvRuLj\nYx++GqhdwFTHDFdrJgEx3Q==\n-----END PRIVATE KEY-----\n","client_email":"docker-build@sleekr-hr-staging.iam.gserviceaccount.com"}'

EXPOSE 3000

# The default command that gets ran will be to start the Puma server.
CMD bundle exec puma -C config/puma.rb