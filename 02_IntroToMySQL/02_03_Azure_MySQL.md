# Introduction to Azure Database for MySQL

As mentioned previously, developers can deploy MySQL on Azure through Virtual Machines (IaaS) or Azure Database for MySQL (PaaS). Though PaaS offerings do not support direct management of the OS and the database engine, they have built-in support for high availability, automating backups, and meeting compliance requirements. Moreover, Azure Database for MySQL supports MySQL Community Editions 5.6, 5.7, and 8.0, making it flexible for most migrations. For most use cases, Azure PaaS MySQL allows developers to focus on application development and deployment, instead of OS and RDBMS management, patching, and security.

As the image below demonstrates, Azure Resource Manager handles resource configuration, meaning that standard Azure management tools, such as the CLI, PowerShell, and ARM templates, are still applicable. This is termed the *control plane*.

For managing database objects and access controls on those objects, standard MySQL management tools, such as [MySQL Workbench](https://www.mysql.com/products/workbench/), still apply. This is known as the *data plane*.

![This image demonstrates the control plane for Azure PaaS MySQL.](./media/mysql-conceptual-diagram.png "Control plane for Azure PaaS MySQL")

## Azure Database for MySQL Deployment Modes

Azure provides both *Single Server* and *Flexible Deployment* modes. Below is a summary of these offerings. For a more comprehensive comparison table, please consult [this document.](https://docs.microsoft.com/azure/mysql/select-right-deployment-type)

### Single Server

Single Server is suitable when apps do not need extensive database customization. Single Server will manage patching, offer high availability, and manage backups on a predetermined schedule (though developers can set the backup retention times between a week and 35 days). To reduce compute costs, developers can [pause the Single Server offering.](https://docs.microsoft.com/azure/mysql/how-to-stop-start-server) It offers an [SLA of 99.99%](https://azure.microsoft.com/updates/azure-database-for-mysql-general-availability/).

> For a refresher on how the SLAs of individual Azure services affect the SLA of the total deployment, review the associated [Microsoft Learn Module.](https://docs.microsoft.com/learn/modules/choose-azure-services-sla-lifecycle/)

### Flexible Server

Flexible Server is also managed by the Azure platform, but it exposes more control to the user. Cost management is one of the major advantages of Flexible Server: it supports a *burstable* tier, which is based on the B1MS Azure VM tier and is optimized for workloads that do not continually use the CPU. Just like Single Server, [Flexible Server can also be paused.](https://docs.microsoft.com/azure/mysql/flexible-server/how-to-restart-stop-start-server-cli) The image below shows how Flexible Server works for a non-high availability arrangement.

> *Locally-redundant storage* replicates data within a single *availability zone*. *Availability zones* are present within a single Azure region (such as East US) and are geographically isolated. All Azure regions that support availability zones have at least three.

![This image demonstrates how MySQL Flexible Server works, with compute, storage, and backup storage.](./media/flexible-server.png "Operation of MySQL Flexible Server")

#### High Availability

The image above does not feature high availability. Flexible Server implements HA by provisioning another VM to serve as a standby.

It is possible to provision this secondary Flexible Server VM in another availability zone, as shown below. As mentioned previously, this HA option is only supported for Azure regions with availability zones. While this option does provide redundancy against zonal failure, there is more latency between the zones that affects replication.

![This image demonstrates Zone-Redundant HA for MySQL Flexible Server.](media/1-flexible-server-overview-zone-redundant-ha.png "Zone-Redundant HA")

To compensate for the latency challenges, Azure provides HA within a single zone. In this configuration, both the primary node and the standby node are in the same zone. All Azure regions support this mode. Of course, it does not insulate against zonal failure.

![This image demonstrates HA for MySQL Flexible Server in a single zone.](./media/flexible-server-overview-same-zone-ha.png "HA in a single zone")

To learn more about HA with MySQL Flexible Server, consult the [documentation.](https://docs.microsoft.com/azure/mysql/flexible-server/concepts-high-availability)

#### Flexible Server Pricing & TCO

All three MySQL Flexible Server tiers offer a storage range between 20 GiB and 16 TiB and the same backup retention period range of 1-35 days. However, they differ in core count and memory per vCore. Choosing a compute tier affects the database IOPS and pricing.

- Burstable: This tier corresponds to a B-series Azure VM. Instances provisioned in this tier have 1-2 vCores. It is ideal for applications that do not utilize the CPU consistently.
- General Purpose: This tier corresponds to a Ddsv4-series Azure VM. Instances provisioned in this tier have 2-64 vCores and 4 GiB memory per vCore. It is ideal for most enterprise applications requiring a strong balance between memory and vCore count.
- Memory Optimized: This tier corresponds to an Edsv4-series Azure VM. Instances provisioned in this tier have 2-64 vCores and 8 GiB memory per vCore. It is ideal for high-performance or real-time workloads that depend on in-memory processing.

To estimate the TCO for Azure Database for MySQL, use the [Azure Pricing Calculator](https://azure.microsoft.com/pricing/calculator/). Note that you can also use the [Azure TCO Calculator](https://azure.microsoft.com/pricing/tco/calculator/) to estimate the cost savings of deploying PaaS Azure MySQL over the same deployment in an on-premises data center. Simply indicate your on-premises hardware and the Azure landing zone, adjust calculation parameters, like the cost of electricity, and observe the potential savings.

#### Flexible Server Unsupported Features

Azure provides a [detailed list of the limitations of Flexible Server](https://docs.microsoft.com/azure/mysql/flexible-server/concepts-limitations). Here are a few notable ones.

- Support for only the InnoDB and MEMORY storage engines; MyISAM is unsupported
- The DBA role and the `SUPER` privilege are unsupported
- `SELECT ... INTO OUTFILE` statements to write query results to files are unsupported, as the filesystem is not directly exposed by the service
