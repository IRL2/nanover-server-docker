# NanoVer server docker image

A docker file (containerized environment) for running NanoVer server with all necessary dependencies installed.


## Use case

Use this repo to build your own image and run a container.

Using a containerized server simplifies the environment setup and execution for some users, i.e.:
- Users with problematic or nonstable python environments
- Those who want a straight-forward user approach
- Move us one step forward to running cloud servers


This image follows the [official nanover documentation](https://irl2.github.io/nanover-docs/) to install the server.

This image contains:
- python 3.11
- a conda environment
- the `nanover-server` package installed and ready to run
- an activated conda nanover environment
- all server dependancies installed, including jupyter to run notebooks
- a copy of the `nanover-server-py` repo (this include all the tutorials!)

## Requirements

The single requirement is the Docker Engine. It can be installed through the corresponding Docker Desktop App per OS.

- On Windows, it requires to preinstall [WSL](https://learn.microsoft.com/en-gb/windows/wsl/install). We recommend to follow the official guide to install [Docker Desktop on Windows](https://docs.docker.com/desktop/setup/install/windows-install/)
- For OSX, also recommend to use [Docker Desktop on Mac](https://docs.docker.com/desktop/setup/install/mac-install/)
- For Linux, you can directly install the [Docker Engine for Linux](https://docs.docker.com/engine/install/)

Be sure that this programs are running before running the container.

## Usage


### Scripts

The `nanover` bash script contains the tools to build the image and run a container

1. **Build and run the server:**
On Linux
   ```bash
   chmod +x nanover
   ./nanover
   ```
On Windows (with wsl installed)
```
bash nanover
```

2. **Or use specific commands:**
```bash
   
   # Run a nanover server with some demo simulations (Default)
   ./nanover demo
 
   # Run a nanover server with custom arguments, like provided simulations
   ./nanover omni --omm /data/my_simulation.xml

   # Run the tutorial jupyter notebooks
   ./nanover notebook

   # Run an external jupyter notebooks
   ./nanover notebook --path /data/notebooks/
   
   # Start interactive shell to run nanover commands from the inside
   ./nanover shell
```

## Inside the image

The container expects the following local directories (automatically created):

```
├── data/          # Use it to load input files, like xml simulations, pdb files, state/traj recordings or ipynd notebooks
├── config/        # Configuration files
└── output/        # Output files, where recordings are placed
```

Inside the image, there is an `/app` directory at root level, containing
- The `entrypoint.sh` script, with the actual run and notebook commands
- A copy of the [nanover-server-py](https://github.com/IRL2/nanover-server-py) repository, containing server code and all the tutorials


## Port Mapping & Network Access

### Local Network Access
The container is configured to bind ports to all network interfaces (`0.0.0.0`), making them accessible from other devices on your local network.

- `8888`  - HTTP jupyter notebook port
- `38801` - NanoVer default port 1
- `38802` - NanoVer default port 2
- `38803` - NanoVer default port 3
- `54545` - NanoVer discovery port

### Accessing from Other Devices
Once running, other devices on your local network can connect using your host machine's IP address:

```bash
# Find your host IP address
ip addr show  # Linux
ifconfig      # macOS/Linux
ipconfig      # Windows

# Example connections from other devices:
# http://192.168.1.100:8080
# nanover://192.168.1.100:38801
```

### Network Security Considerations
- **Firewall**: Ensure your host firewall allows connections on these ports
- **Router**: Most home routers allow local network communication by default
- **Security**: Consider using specific IP binding for production environments


## Building
 To rebuild the image, run the `build.sh` script
