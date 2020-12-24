FROM redmine:latest

# plugins
RUN git clone https://github.com/sciyoshi/redmine-slack.git /usr/src/redmine/plugins/redmine_slack && \
  git clone https://github.com/suer/redmine_webhook.git /usr/src/redmine/plugins/redmine_webhook && \
  git clone https://github.com/twinslash/redmine_omniauth_google.git /usr/src/redmine/plugins/redmine_omniauth_google

# themes
RUN git clone https://github.com/farend/redmine_theme_farend_basic.git /usr/src/redmine/public/themes/farend_basic

COPY configuration.yml /usr/src/redmine/config/configuration.yml

# required native extensions
RUN apt-get update \
  && apt-get install -y gcc g++ make libffi6 \
  && bundle install
