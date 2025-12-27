# From the Deep

In this problem, you'll write freeform responses to the questions provided in the specification.

## Random Partitioning

Advantages:

Random allocation maintains an even distribution across boats, providing a low-complexity solution with minimal system overhead.

Disadvantages:

Since range-specific queries necessitate a broadcast across all boats, they often suffer from heightened latency and diminished operational efficiency. The lack of data locality further degrades performance for aggregation and grouping tasks.



## Partitioning by Hour

Advantages:

By localizing temporal data to specific units, the overhead of querying multiple boats for time-sensitive searches is mitigated. This approach streamlines time-limited queries, ensuring faster response times for localized intervals like midnight to 1 AM.

Disadvantages:

Concentrated data influxes during specific windows can overwhelm individual boats, compromising overall system stability. Maintaining optimal performance requires proactive management and the manual adjustment of range boundaries as observation frequency shifts over time.

## Partitioning by Hash Value

Advantages:

By maintaining a balanced storage footprint across the cluster, the system eliminates potential hotspots and resource exhaustion. This architecture enables high-efficiency lookups for exact timestamps, as requests are pinpointed to specific boats rather than being broadcast.

Disadvantages:

The non-contiguous nature of hash outputs forces range queries to scan the entire cluster, leading to increased latency for time-window searches. Furthermore, implementing this strategy requires more sophisticated management of the hashing layer and complicates the diagnostic process during system failures.
