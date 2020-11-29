FROM prom/prometheus
ADD prometheus.yml /etc/prometheus/
COPY ./scrape-targets/scrape-targets.json /tmp/scrape-targets.json
