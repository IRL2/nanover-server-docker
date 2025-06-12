# NanoVer server docker image

A docker file (containerized environment) for running NanoVer server with all necessary dependencies installed

It follows the [official nanover documentation](https://irl2.github.io/nanover-docs/)

This image contains:
- python 3.11
- a conda environment
- the `nanover-server` package installed and ready to run
- all dependancies including jupyter to run notebooks
- a copy of the `nanover-server-py` repo

## Use case

Taken as a distribution channel, a docker simplify the server execution for some users:
- Users with problematic or nonstable python environments
- Those who want a straight-forward user approach

## Quick Start

The `build.sh` bash script contains the tools to build the image and run a container

1. **Build and run the server:**
   ```bash
   chmod +x build.sh
   ./build.sh
   ```

2. **Or use specific commands:**
```bash
   
   # Run a nanover server with some demo simulations
   ./build.sh run
   
   # Run a nanover server with custom arguments, like provided simulations
   ./build.sh run --omm /data/my_simulation.xml

   # Run the tutorial jupyter notebooks
   ./build.sh notebook

   # Run an external jupyter notebooks
   ./build.sh notebook --path /data/notebooks/

   
   # Start interactive shell to run nanover commands from the inside
   ./build.sh shell

   # Build the docker image only
   ./build.sh build
   
```

## Directory Structure

The container expects the following local directories (automatically created):

```
├── data/          # Input files, like xml simulations, pdb files, state/traj recordings or ipynd notebooks
├── config/        # Configuration files
├── output/        # Output files, where recordings are placed
├── Dockerfile
├── docker-compose.yml
├── build.sh
└── README.md
```


## Port Mapping & Network Access

### Local Network Access
The container is configured to bind ports to all network interfaces (`0.0.0.0`), making them accessible from other devices on your local network.

- `8888`  - HTTP jupyter notebook port
- `38801` - NanoVer default port 1
- `38802` - NanoVer default port 2
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


