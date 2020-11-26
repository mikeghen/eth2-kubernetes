FROM sigp/lighthouse:v1.0.0

COPY ./entrypoint.sh /root/entrypoint.sh
COPY ./pyrmont/validators /root/prymont/validator

ENTRYPOINT ['/root/entrypoint.sh']
