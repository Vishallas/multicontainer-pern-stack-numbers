# Multicontainer application P-E-R-N Stack

It contains React client, Node.js backend, PostgreSQL and Nginx

You can run it in development mode: `docker-compose up --build`

For production mode I planned to use AWS EKS.

# Architecture

I have use seperate architecture for Development and Production mode.

## Development

The development mode has React app directly accessed by the main nginx server.

![muliticontainer_r2np_architecture_dev_drawio](https://github.com/Vishallas/multicontainer-pern-stack-numbers/assets/103063354/edfb4420-fbd6-41c1-b382-390cbf6309ad)

## Production

The production mode has the seperate nginx server for frontend where the build contents of the react app where used.

![multicontainer_r2np_architecture_prod_drawio](https://github.com/Vishallas/multicontainer-pern-stack-numbers/assets/103063354/833dbdc2-f6ba-486d-bef4-039df955d31f)
hello