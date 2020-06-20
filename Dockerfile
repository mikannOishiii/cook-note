# Node.js & Yarn
FROM node:10.15.1-stretch-slim

RUN apt-get update \
  && apt-get install -y --no-install-recommends curl nodejs \
  && curl -o- -L https://yarnpkg.com/install.sh | bash -s -- --version 1.22.4 \
  && apt-get -y remove curl \
  && apt-get -y clean \
  && rm -rf /var/lib/apt/lists/*

# Ruby
FROM ruby:2.6.5-slim

COPY --from=node /usr/local/bin/node /usr/local/bin/node
COPY --from=node /opt/yarn-* /opt/yarn
RUN ln -fs /opt/yarn/bin/yarn /usr/local/bin/yarn

ENV BLD_PACKAGES="curl gnupg wget unzip"
ENV BUNDLE_PACKAGES="build-essential libxslt-dev libxml2-dev libmariadb-dev default-libmysqlclient-dev"
ENV ENTRYKIT_VERSION 0.4.0

# Entrykit & ChromeDriver & BLD_PACKAGES
RUN apt-get update \
  && apt-get install -y --no-install-recommends ${BLD_PACKAGES} \
  && wget https://github.com/progrium/entrykit/releases/download/v${ENTRYKIT_VERSION}/entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && tar -xvzf entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && rm entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && mv entrykit /bin/entrykit \
  && chmod +x /bin/entrykit \
  && entrykit --symlink \
  && CHROMEDRIVER_VERSION=`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE` \
  && wget -N http://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip -P ~/ \
  && unzip ~/chromedriver_linux64.zip -d ~/ \
  && rm ~/chromedriver_linux64.zip \
  && chown root:root ~/chromedriver \
  && chmod 755 ~/chromedriver \
  && mv ~/chromedriver /usr/bin/chromedriver \
  && sh -c 'wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -' \
  && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' \
  && apt-get update && apt-get install -y google-chrome-stable \
  && apt-get -y clean \
  && rm -rf /var/lib/apt/lists/*

# nokogiri & mysql Install with included libraries
RUN apt-get update \
  && apt-get install -y --no-install-recommends ${BUNDLE_PACKAGES} \
  && apt-get -y clean \
  && rm -rf /var/lib/apt/lists/*

# 作業ディレクトリの作成、設定
RUN mkdir /cook-note
WORKDIR /cook-note

# bundle install & Copy File
COPY Gemfile /cook-note/Gemfile
COPY Gemfile.lock /cook-note/Gemfile.lock
RUN bundle install
COPY . /cook-note

ENTRYPOINT [ \
  "prehook", "bundle install -j3", "--", \
  "prehook", "ruby -v", "--", \
  "prehook", "node -v", "--" \
]
