//Require module
const express = require('express');
const { Client } = require('pg');

const app = express();
const port = process.env.SERVER_PORT;


app.listen(port, () => {
    console.log('starting api');
})


app.get('/', async (req,res)=>{
    const dt = new Date().toString();
    console.log(`request received at ${dt}`);

    const postgres_client = new Client({
        user: 'postgres',
        host: process.env.APP_DB_HOST,
        database: 'postgres',
        password: process.env.APP_DB_PASSWORD,
        port: 5432,
    });
    try {
        // not ideal
        postgres_client.connect();
        const query = `select value from public.api_response;`;
        const result = await postgres_client.query(query);
        console.log(result.rows[0].value);
        res.send(`${result.rows[0].value}`);
    } catch (err) {
        console.log(err.stack);
    } finally {
        postgres_client.end();
    }

})
