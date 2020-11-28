FROM prom/prometheus
ADD prometheus.yml /etc/prometheus/
COPY ./scrape-targets/scrape-targets.json /prometheus/targets/scrape-targets.json
