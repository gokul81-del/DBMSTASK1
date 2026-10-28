# Task XIII — Database Security and Performance Optimization

## Requirements

1. Create database users and roles.
2. Implement GRANT and REVOKE commands.
3. Apply access control.
4. Create indexes for faster searching.
5. Analyze and optimize query performance.

## SQL File

- `security_performance.sql` — Contains role and user setup, access permissions, indexes, and query performance analysis statements.

## Security Features

- Creates a read-only role and a data-entry role.
- Grants each role only the permissions needed for its purpose.
- Creates sample database users and assigns roles.
- Demonstrates how to revoke a permission.

## Performance Features

- Adds indexes for common customer, product, order, payment, and order-detail searches.
- Uses `EXPLAIN` to inspect query execution plans.
- Includes sample search queries that can be analyzed.

## Execution

Run Tasks I to V first. Execute `security_performance.sql` using a MySQL account with permission to create users, roles, indexes, and grants.

Change the example usernames and passwords before using this script outside a local assignment database. User and role creation may require administrative privileges. Indexes can improve reads but add storage and write overhead.
