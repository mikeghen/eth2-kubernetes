FROM prom/prometheus
ADD prometheus.yml /etc/prometheus/
COPY ./scrape-targets/scrape-targets.json /temp/scrape-targets.json
