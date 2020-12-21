FROM bitnami/redmine:4

WORKDIR /opt/bitnami/redmine

# plugins
RUN git clone https://github.com/sciyoshi/redmine-slack.git  /opt/bitnami/redmine/plugins/redmine_slack && \
  git clone https://github.com/suer/redmine_webhook.git /opt/bitnami/redmine/plugins/redmine_webhook

# themes
RUN git clone https://github.com/farend/redmine_theme_farend_basic.git /opt/bitnami/redmine/public/themes/farend_basic

RUN bundle config unset deployment && \
    bundle install && \
    bundle config set --local deployment true
