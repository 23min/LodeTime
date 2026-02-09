FROM elixir:1.19.5-otp-28

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    curl \
    wget \
    inotify-tools \
    jq \
    fzf \
    ripgrep \
    fd-find \
    bat \
    htop \
    tmux \
    zsh \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Install Go
ENV GO_VERSION=1.22.0
RUN wget -q https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz \
    && rm go${GO_VERSION}.linux-amd64.tar.gz

ENV PATH="/usr/local/go/bin:/home/vscode/go/bin:${PATH}"
ENV GOPATH="/home/vscode/go"

# Install yq
RUN wget -q https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/local/bin/yq \
    && chmod +x /usr/local/bin/yq

# Create vscode user
RUN useradd -m -s /bin/zsh vscode \
    && echo "vscode ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
    && mkdir -p /home/vscode/.vscode-server/extensions \
    && mkdir -p /home/vscode/.vscode-server/bin \
    && mkdir -p /home/vscode/.vscode-server/data \
    && chown -R vscode:vscode /home/vscode

USER vscode
WORKDIR /home/vscode

# Install Elixir tools
RUN mix local.hex --force && mix local.rebar --force

# Install Go tools
RUN go install golang.org/x/tools/gopls@latest \
    && go install github.com/go-delve/delve/cmd/dlv@latest \
    && go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest

# Setup zsh with oh-my-zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Install oh-my-posh for PowerShell theming
RUN curl -s https://ohmyposh.dev/install.sh | bash -s

# Create directories
RUN mkdir -p /home/vscode/bin /home/vscode/.shell_history

ENV PATH="/home/vscode/bin:/workspace/bin:${PATH}"

WORKDIR /workspace
