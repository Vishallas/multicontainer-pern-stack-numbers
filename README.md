# Multicontainer application P-E-R-N Stack

It contains React client, Node.js backend, PostgreSQL and Nginx

You can run it in development mode: `docker-compose up --build`

For production mode I planned to use AWS EKS.

# Architecture

I have use seperate architecture for Development and Production mode.

## Development

The development mode has React app directly accessed by the main nginx server.



## Production

The production mode has the seperate nginx server for frontend where the build contents of the react app where used.

