FROM python:3.15.2-slim

ENV VIRTUAL_ENV=/opt/venv \
    PATH=/opt/venv/bin:$PATH \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Libraries go to /opt/venv, outside /app, so that mounting the bot code at
# /app does not hide them.
RUN groupadd -g 1000 bot && \
    useradd -l -u 1000 -g bot -d /app -M bot && \
    python -m venv /opt/venv

COPY requirements.txt /opt/requirements.txt
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install -r /opt/requirements.txt && \
    python -c "import discord, lxml.html, PIL.Image"

USER bot
WORKDIR /app

CMD ["python"]
