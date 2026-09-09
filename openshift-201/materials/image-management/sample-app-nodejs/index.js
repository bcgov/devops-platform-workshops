const express = require('express');
const cookieParser = require('cookie-parser');
const csrf = require('csurf');
const app = express();
const port = 8080;

app.use(cookieParser());
app.use(csrf({ cookie: true }));

// Get environment variables with default values
const envVar1 = process.env.NAME || 'unkonwn';
const envVar2 = process.env.APP_MSG || '';

// Define a route to return the environment variables as JSON
// Note: SECRET_APP_MSG is intentionally never exposed via this public,
// unauthenticated endpoint.
app.get('/', (req, res) => {
  res.send(`Hello world from ${envVar1} ${envVar2}`);
});

// Start the server
app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
