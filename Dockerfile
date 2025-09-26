FROM debian:bookworm-slim

# Install Python 3.11 via apt from Debian repositories
RUN apt-get update && apt-get install -y \
    python3.11 python3.11-dev python3-pip python3.11-venv \
    python3-gi python3-gi-cairo libcairo2-dev pkg-config gobject-introspection \
    libjpeg-dev zlib1g-dev gir1.2-pango-1.0 \
    && rm -rf /var/lib/apt/lists/*

RUN python3.11 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Use pip from the venv to install dependencies
RUN pip install --no-cache-dir --force-reinstall pycairo
RUN pip install pynacl
ENV PYTHONPATH=/usr/lib/python3/dist-packages
ENV FONTCONFIG_FILE=/bot/extra/fonts.conf
ENV PYTHONUNBUFFERED=1

WORKDIR /bot
COPY pyproject.toml .
RUN python3.11 -m pip install --no-cache-dir .
COPY . .
CMD ["python3.11", "-m", "tle"]
