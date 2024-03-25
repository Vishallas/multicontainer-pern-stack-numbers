const keys = require("./keys");

// Express Application setup
const express = require("express");
const bodyParser = require("body-parser");
const cors = require("cors");

const app = express();
app.use(cors());
app.use(bodyParser.json());

// Postgres client setup
const { Pool } = require("pg");
const pgClient = new Pool({
  user: keys.pgUser,
  host: keys.pgHost,
  database: keys.pgDatabase,
  password: keys.pgPassword,
  port: keys.pgPort
});

pgClient.on("connect", client => {
  client
    .query("CREATE TABLE IF NOT EXISTS values (number INT)")
    .then(res => {
      console.log("Connected to the database successfully.");
    })
    .catch(err => {
      console.log("PG ERROR", err);
    });
});

//Express route definitions
app.get("/", (req, res) => {
  res.send("Hello");
});

// get the values
app.get("/values/all", async (req, res) => {
  try {
    const values = await pgClient.query("SELECT * FROM values");
    console.log("Data received successfully", values.rows);
    res.send(values);
  } catch (err) {
    console.error(err);
    res.status(500).send("Internal Server Error");
  }
});

// now the post -> insert value
app.post("/values", async (req, res) => {
  if (!req.body.value) res.send({ working: false });

  pgClient.query("INSERT INTO values(number) VALUES($1)", [req.body.value]);

  res.send({ working: true });
});

app.listen(5000, err => {
  console.log("Listening");
});
