FROM redmine:latest

# plugins
RUN git clone https://github.com/sciyoshi/redmine-slack.git /usr/src/redmine/plugins/redmine_slack && \
  git clone https://github.com/suer/redmine_webhook.git /usr/src/redmine/plugins/redmine_webhook

# themes
RUN git clone https://github.com/farend/redmine_theme_farend_basic.git /usr/src/redmine/public/themes/farend_basic

COPY configuration.yml /usr/src/redmine/config/configuration.yml
