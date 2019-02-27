const express = require('express');
let app = express();
const SecretValue =require('./mongo');
app.get('/', function (req, res) {
    SecretValue.init();
})
