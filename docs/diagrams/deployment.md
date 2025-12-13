# Simple SMB Daemon - Deployment Diagrams

## Basic Deployment Architecture

```mermaid
graph TB
    subgraph "SMB Clients"
        Client1[SMB Client 1]
        Client2[SMB Client 2]
        ClientN[SMB Client N]
    end

    subgraph "SMB Server"
        Server[simple-smbd<br/>Main Process]
        Config[/etc/simple-smbd/<br/>Configuration]
        Shares[/var/samba/shares<br/>Shared Directories]
        Logs[/var/log/simple-smbd/<br/>SMB Logs]
    end

    subgraph "System Services"
        Systemd[systemd<br/>Service Manager]
    end

    Client1 --> Server
    Client2 --> Server
    ClientN --> Server

    Systemd --> Server
    Systemd --> Config

    Server --> Config
    Server --> Shares
    Server --> Logs
```
